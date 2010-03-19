module Bean
  module User
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        has_many :transfers, :class_name => 'Bean::Transfer'
      end
      
      Bean::Transfer.class_eval do
        belongs_to :user, :class_name => base.name
      end
    end
    
    module InstanceMethods
      def balance(account='asset',currency='USD')
        debits = transfers.debiting(account).in_currency(currency).sum(:amount)
        credits = transfers.crediting(account).in_currency(currency).sum(:amount)
        Money.new(debits - credits, currency.to_s)
      end
      
      def credit_card
      end
    end
  end
end