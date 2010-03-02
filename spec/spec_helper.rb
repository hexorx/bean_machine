$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'sqlite3'
require 'active_record'
require 'spec'
require 'spec/autorun'

require 'billing'

ActiveRecord::Base.establish_connection(:adapter  => 'sqlite3', :database => ':memory:')
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
require File.dirname(__FILE__) + '/spec_helper'

require 'schema'
require 'blueprints'

Billing::Payment.gateway = ActiveMerchant::Billing::TrustCommerceGateway.new(
    :login    => 'TestMerchant',	
    :password => 'password'
  )

Spec::Runner.configure do |config|
  config.before(:all)    { Sham.reset(:before_all)  }
  config.before(:each)   { Sham.reset(:before_each) }
end
