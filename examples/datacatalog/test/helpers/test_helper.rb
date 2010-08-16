require 'rubygems'

require 'test/unit'

require 'rack/test'
require 'rr'

gem 'crack', '>= 0.1.4'
require 'crack/json'

gem 'tu-context', '>= 0.5.8'
require 'tu-context'

gem 'pending', '>= 0.1.1'
require 'pending'

require 'timecop'

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
