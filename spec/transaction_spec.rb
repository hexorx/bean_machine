require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Billing::Transaction do
  describe 'amount' do
    it 'should be Money' do
      Billing::Transaction.make_unsaved.amount.should be_a(Money)
    end
    
    it 'should be more than zero' do
      Billing::Transaction.make_unsaved(:amount => 1.to_money).should be_valid
      Billing::Transaction.make_unsaved(:amount => 0.to_money).should be_invalid
      Billing::Transaction.make_unsaved(:amount => -1.to_money).should be_invalid
    end    
  end
  
  describe 'debit & credit' do
    it 'should be an account' do
      Billing::Transaction.make_unsaved(:debit => 'monkey').should be_invalid
      Billing::Transaction.make_unsaved(:credit => 'monkey').should be_invalid
      Billing::Transaction.make_unsaved(:debit => 'asset').should be_valid
      Billing::Transaction.make_unsaved(:credit => 'asset').should be_valid
    end
  end
  
  describe 'scopes' do
    before(:all) do
      Billing::Transaction.destroy_all
      Billing::Transaction.make(:credit => 'asset', :debit => 'liability', :amount => Money.new(rand(100)+1, 'MONKEY'))
      Billing::Transaction.make(:credit => 'asset', :debit => 'expense', :amount => Money.new(rand(100)+1, 'USD'))
      Billing::Transaction.make(:credit => 'payment', :debit => 'asset', :amount => Money.new(rand(100)+1, 'USD'))
      Billing::Transaction.make(:credit => 'payment', :debit => 'expense', :amount => Money.new(rand(100)+1, 'USD'))
      Billing::Transaction.make(:credit => 'payment', :debit => 'currency', :amount => Money.new(rand(100)+1, 'USd'))
      Billing::Transaction.make(:credit => 'currency', :debit => 'income', :amount => Money.new(rand(100)+1, 'MONKEY'))
    end

    it 'should scope by debit account' do
      Billing::Transaction.debiting(:asset).count.should == 1
      Billing::Transaction.debiting(:liability).count.should == 1
      Billing::Transaction.debiting(:expense).count.should == 2
      Billing::Transaction.debiting(:income).count.should == 1
      Billing::Transaction.debiting(:currency).count.should == 1
    end

    it 'should scope by credit account' do
      Billing::Transaction.crediting(:asset).count.should == 2
      Billing::Transaction.crediting(:payment).count.should == 3
      Billing::Transaction.crediting(:currency).count.should == 1
    end
    
    it 'should scope by currency' do
      Billing::Transaction.in_currency(:USD).count.should == 4
      Billing::Transaction.in_currency(:MONKEY).count.should == 2
    end
    
  end
end
