require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Billing::User do
  describe 'balance' do
    before(:all) do
      @user = User.make
      Billing::Transaction.destroy_all
      @user.transactions.make(:credit => 'asset', :debit => 'liability', :amount => Money.new(100, 'MONKEY'))
      @user.transactions.make(:credit => 'asset', :debit => 'expense', :amount => Money.new(200, 'USD'))
      @user.transactions.make(:credit => 'payment', :debit => 'asset', :amount => Money.new(300, 'USD'))
      @user.transactions.make(:credit => 'payment', :debit => 'expense', :amount => Money.new(400, 'USD'))
      @user.transactions.make(:credit => 'payment', :debit => 'currency', :amount => Money.new(500, 'USd'))
      @user.transactions.make(:credit => 'currency', :debit => 'income', :amount => Money.new(600, 'MONKEY'))
    end

    it 'should return a money object' do
      @user.balance(:asset).should be_a(Money)
    end
    
    it 'should default to assets in USD' do
      @user.balance.should == Money.new(100,'USD')
    end
    
    it 'should take the account as the first option and currency as the second' do
      @user.balance(:liability, :monkey).should == Money.new(100,'MONKEY')
      @user.balance(:income, :monkey).should == Money.new(600,'MONKEY')
      @user.balance(:currency, :monkey).should == Money.new(-600,'MONKEY')
      @user.balance(:currency, :usd).should == Money.new(500,'USD')
      @user.balance(:expense, :usd).should == Money.new(600,'USD')
      @user.balance(:payment, :usd).should == Money.new(-1200,'USD')
    end
  end
  
end
