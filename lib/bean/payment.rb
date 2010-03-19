module Bean
  class Payment < ActiveRecord::Base
    include Bean::Machine
    
    cattr_accessor :gateway
    
    composed_of :amount, :class_name => 'Money', :mapping => [%w(amount cents), %w(currency currency)]
    
    attr_accessor :credit_card
    
    def authorize(amount=amount, options = {})
      return false if bean
      card = options.delete(:on) || (credit_card rescue nil)
      return false unless card
      
      process(amount,{
        :event => 'authorize',
        :state => 'authorized',
        :credit => 'payment',
        :debit =>'pending'
      }) do |gw|
        gw.authorize(amount, card, options)
      end
    end

    def capture(options = {})
      return false unless bean.state == 'authorized'
      
      process(amount,{
        :event => 'capture',
        :state => 'captured',
        :credit => 'pending',
        :debit =>'cash'
      }) do |gw|
        gw.capture(amount, bean.reference, options)
      end
    end

    private

    def process(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      amount = args.shift.to_money
      
      transfer(amount, options) do
        begin
          response = yield Payment.gateway

          self.success   = response.success?
          self.reference = response.authorization
          self.message   = response.message
          self.params    = response.params
          self.test      = response.test
        rescue ActiveMerchant::ActiveMerchantError => e
          self.state = 'declined'
          self.success   = false
          self.reference = nil
          self.message   = e.message
          self.params    = {}
          self.test      = gateway.test?
        end
      end

    end
  end
end