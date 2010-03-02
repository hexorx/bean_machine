require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Billing::Payment do
  before(:all) do
    @user = User.make
    Billing::Transaction.destroy_all
  end
  
  describe 'authorization' do
    before(:all) do
      @credit_card = ActiveMerchant::Billing::CreditCard.make
      @bad_authorization = Billing::Payment.authorize(100.to_money, :from => @user)
      @good_authorization = Billing::Payment.authorize(100.to_money, :from => @user, :on => @credit_card)
    end
    
    it 'should return the authorization transaction' do
      @good_authorization.should be_a(Billing::Payment)
    end
    
    it 'should credit the payment account' do
      @good_authorization.credit.should == 'payment'
    end

    it 'should debit the asset account' do
      @good_authorization.debit.should == 'asset'
    end
    
    it 'should save the record ... always' do
      @good_authorization.should_not be_a_new_record
    end
    
    it 'should set the amount' do
      @good_authorization.amount.should be_a(Money)
    end

    it 'should set the user' do
      @good_authorization.user.should == @user
    end
        
    describe 'invalid card' do
      it 'should not succeed' do
        @bad_authorization.should_not be_a_success
      end
      
      it 'should not return a reference number on bad authorization' do
        @bad_authorization.reference.should be_nil
      end
      
      it 'should set a error message' do
        @bad_authorization.message.should == 'One or more parameters required for this transaction type were not sent'
      end
    end
    

    describe 'valid card' do      
      it 'should succeed with a valid card' do
        @good_authorization.should be_a_success
      end
    
      it 'should return a reference number' do
        @good_authorization.reference.should_not be_nil
      end
      
      it 'should set a success message' do
        @good_authorization.message.should == 'The transaction was successful'
      end
    end
  end
end
