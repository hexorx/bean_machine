module Billing
  class Payment < Transaction
    cattr_accessor :gateway
    
    def self.authorize(amount, options={})
      credit_card = options.delete(:on) || options[:from].try(:credit_card) || ActiveMerchant::Billing::CreditCard.new
      user = options.delete(:from) || credit_card.try(:user)
      
      process('authorization', user, amount) do |gw|
        gw.authorize(amount, credit_card, options)
      end
    end
    
    def self.process(action, user, amount = nil)
      result = self.new
      result.user = user
      result.amount = amount
      result.action = action
      
      result.credit = 'payment'
      result.debit = 'asset'

      begin
        response = yield gateway

        result.success   = response.success?
        result.reference = response.authorization
        result.message   = response.message
        result.params    = response.params
        result.test      = response.test?
      rescue ActiveMerchant::ActiveMerchantError => e
        result.success   = false
        result.reference = nil
        result.message   = e.message
        result.params    = {}
        result.test      = gateway.test?
      end
      
      result.save
      result
    end
  end
end