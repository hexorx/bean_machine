module Billing
  module User
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        has_many :transactions, :class_name => 'Billing::Transaction'
      end
      
      Billing::Transaction.class_eval do
        belongs_to :user, :class_name => base.name
      end
    end
    
    module InstanceMethods
      def balance(account='asset',currency='USD')
        debits = transactions.debiting(account).in_currency(currency).sum(:amount)
        credits = transactions.crediting(account).in_currency(currency).sum(:amount)
        Money.new(debits - credits, currency.to_s)
      end
      
      def credit_card
      end
    end
  end
end