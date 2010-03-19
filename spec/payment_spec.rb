require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Bean::Payment do
  before(:all) do
    Bean::Transfer.destroy_all
    @user = User.make
    @payment = Bean::Payment.make(:amount => 10.to_money)
  end
  
  describe 'authorize' do    
    before(:all) do
      @transfer = @payment.authorize
    end

    it 'should add a transfer' do
      @payment.transfers.size.should == 1
    end
    
    it 'should set the amount on the transfer' do
      @transfer.amount.should == '$10'.to_money
    end
    
    it 'should set the event to authorize' do
      @transfer.event.should == 'authorize'
    end
    
    it 'should credit the payment account' do
      @transfer.credit.should == 'payment'
    end
    
    it 'should debit the authorized account' do
      @transfer.debit.should == 'pending'
    end
    
    it 'should fail if there is a state' do
      @payment.authorize.should == false
    end
  end
  
  describe 'capture' do
    before(:all) do
      @authorization = @payment.authorize
      @transfer = @payment.capture
    end
    
    it 'should add a transfer' do
      @payment.transfers.size.should == 2
    end
    
    it 'should set the amount on the transfer' do
      @transfer.amount.should == '$10'.to_money
    end
    
    it 'should set the event to authorize' do
      @transfer.event.should == 'capture'
    end
    
    it 'should credit the pending account' do
      @transfer.credit.should == 'pending'
    end
    
    it 'should debit the cash account' do
      @transfer.debit.should == 'cash'
    end
    
    it 'should fail unless the state is authorized' do
      @payment.capture.should == false
    end
  end
end
