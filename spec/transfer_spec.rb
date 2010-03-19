require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Bean::Transfer do
  describe 'amount' do
    it 'should be Money' do
      Bean::Transfer.make_unsaved.amount.should be_a(Money)
    end
    
    it 'should be more than zero' do
      Bean::Transfer.make_unsaved(:amount => 1.to_money).should be_valid
      Bean::Transfer.make_unsaved(:amount => 0.to_money).should be_invalid
      Bean::Transfer.make_unsaved(:amount => -1.to_money).should be_invalid
    end    
  end
    
  describe 'scopes' do
    before(:all) do
      Bean::Transfer.destroy_all
      Bean::Transfer.make(:credit => 'asset', :debit => 'liability', :amount => Money.new(rand(100)+1, 'MONKEY'))
      Bean::Transfer.make(:credit => 'asset', :debit => 'expense', :amount => Money.new(rand(100)+1, 'USD'))
      Bean::Transfer.make(:credit => 'payment', :debit => 'asset', :amount => Money.new(rand(100)+1, 'USD'))
      Bean::Transfer.make(:credit => 'payment', :debit => 'expense', :amount => Money.new(rand(100)+1, 'USD'))
      Bean::Transfer.make(:credit => 'payment', :debit => 'currency', :amount => Money.new(rand(100)+1, 'USd'))
      Bean::Transfer.make(:credit => 'currency', :debit => 'income', :amount => Money.new(rand(100)+1, 'MONKEY'))
    end

    it 'should scope by debit account' do
      Bean::Transfer.debiting(:asset).count.should == 1
      Bean::Transfer.debiting(:liability).count.should == 1
      Bean::Transfer.debiting(:expense).count.should == 2
      Bean::Transfer.debiting(:income).count.should == 1
      Bean::Transfer.debiting(:currency).count.should == 1
    end

    it 'should scope by credit account' do
      Bean::Transfer.crediting(:asset).count.should == 2
      Bean::Transfer.crediting(:payment).count.should == 3
      Bean::Transfer.crediting(:currency).count.should == 1
    end
    
    it 'should scope by currency' do
      Bean::Transfer.in_currency(:USD).count.should == 4
      Bean::Transfer.in_currency(:MONKEY).count.should == 2
    end
    
  end
end
