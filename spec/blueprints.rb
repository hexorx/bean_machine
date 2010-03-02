require 'machinist/active_record'
require 'machinist/object'
require 'sham'
require 'faker'

class User < ActiveRecord::Base
  include Billing::User
end

User.blueprint do
  
end

Billing::Transaction.blueprint do
  amount { Money.new(rand(100) + 1) }
  debit { 'asset' }
  credit { 'expense' }
end

ActiveMerchant::Billing::CreditCard.blueprint do
  number {'4111111111111111'}
  month {'8'}
  year {'2009'}
  first_name {'Tobias'}
  last_name {'Luetke'}
  verification_value {'123'}
end