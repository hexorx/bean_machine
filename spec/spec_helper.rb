$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'sqlite3'
require 'active_record'
require 'spec'
require 'spec/autorun'

require 'bean_machine'

ActiveRecord::Base.establish_connection(:adapter  => 'sqlite3', :database => ':memory:')

require File.dirname(__FILE__) + '/spec_helper'

require 'schema'
require 'blueprints'

Bean::Payment.gateway = ActiveMerchant::Billing::BogusGateway.new

Spec::Runner.configure do |config|
  config.before(:all)    { Sham.reset(:before_all)  }
  config.before(:each)   { Sham.reset(:before_each) }
end
