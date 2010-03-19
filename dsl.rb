class Payment
  cattr_accessor :gateway
  
  def charge
    authorize!(amount).capture!
  end

  def authorize
    transfer :from => :payments, :to => :accounts_recievable
  end

  def capture
    transfer :accounts_recievable => :cash do
      response = gateway.capture(amount, authorization, options)
      record_response(trans, response)
    end
  end
  
  def expire
    transfer :accounts_recievable => :payment
  end
  
  def refund do
    transfer :cash => :payments
  end

protected

  def record_response(trans,response)
    begin
      trans.success   = response.success?
      trans.reference = response.authorization
      trans.message   = response.message
      trans.params    = response.params
      trans.test      = response.test?
    rescue ActiveMerchant::ActiveMerchantError => e
      trans.success   = false
      trans.reference = nil
      trans.message   = e.message
      trans.params    = {}
      trans.test      = gateway.test?
    end
  end  
end