$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
# require 'sqlite3'
require 'active_record'
require 'active_merchant'
require 'spec'
require 'spec/autorun'

require 'bean_machine'
require 'bean/payment'

ActiveRecord::Base.establish_connection(:adapter  => 'sqlite3', :database => ':memory:')

require File.dirname(__FILE__) + '/spec_helper'

require 'schema'
require 'blueprints'

Bean::Payment.gateway = ActiveMerchant::Billing::BogusGateway.new

Spec::Runner.configure do |config|
  config.before(:all)    { Sham.reset(:before_all)  }
  config.before(:each)   { Sham.reset(:before_each) }
end
