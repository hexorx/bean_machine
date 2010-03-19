require 'machinist/active_record'
require 'machinist/object'
require 'sham'
require 'faker'

class User < ActiveRecord::Base
  include Bean::User
end

User.blueprint do
end

Bean::Payment.blueprint do
  amount {}
  credit_card { ActiveMerchant::Billing::CreditCard.make }
end

Bean::Transfer.blueprint do
  amount {Money.new(rand(100) + 1)}
  debit {'asset'}
  credit {'expense'}
end

ActiveMerchant::Billing::CreditCard.blueprint do
  number {'1'}
  month {'8'}
  year {'2009'}
  first_name {'Tobias'}
  last_name {'Luetke'}
  verification_value {'123'}
end

ActiveMerchant::Billing::CreditCard.blueprint(:bad) do
  number {'2'}
end