require 'rubygems'
require 'bundler/setup'
require 'crack/json'
require 'pending'
require 'rack/test'
require 'rr'
require 'test/unit'
require 'timecop'
require 'tu-context'

base = File.dirname(__FILE__)
Dir.glob(base + '/lib/*.rb'       ).each { |f| require f }
Dir.glob(base + '/test_cases/*.rb').each { |f| require f }
Dir.glob(base + '/assertions/*.rb').each { |f| require f }
Dir.glob(base + '/shared/*.rb'    ).each { |f| require f }

require File.expand_path(base + '/../../config/config')
Config.environment = 'test'
class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end

Config.drop_database
