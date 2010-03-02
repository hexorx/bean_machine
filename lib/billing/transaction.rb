module Billing
  Accounts = [:asset, :liability, :expense, :income, :payment, :currency]
  
  class Transaction < ActiveRecord::Base
    set_table_name :billing_transactions
    
    # before_validation :normalize_accounts
    
    composed_of :amount, :class_name => 'Money', :mapping => [%w(amount cents), %w(currency currency)]
    
    named_scope :debiting, lambda {|account|
      {:conditions => {:debit => account.to_s.downcase}}
    }

    named_scope :crediting, lambda {|account|
      {:conditions => {:credit => account.to_s.downcase}}
    }

    named_scope :in_currency, lambda {|currency|
      {:conditions => {:currency => currency.to_s.upcase}}
    }
    
    def before_validation_with_normalizing
      self[:debit].downcase!
      self[:credit].downcase!
      self[:currency].upcase!
      before_validation_without_normalizing
    end
    alias_method_chain :before_validation, :normalizing
    
  protected
  
    def validate
      errors.add(:amount, 'must be positive') unless self.amount > Money.new(0,self.currency)
      errors.add(:debit, 'must be a valid account') unless Billing::Accounts.include?(self.debit.to_sym)
      errors.add(:credit, 'must be a valid account') unless Billing::Accounts.include?(self.credit.to_sym)
    end
    
  end
end