require 'rubygems'

require 'test/unit'
require 'rack/test'
require 'rr'

gem 'crack', '>= 0.1.4'
require 'crack/json'

gem 'djsun-context', '>= 0.5.6'
require 'context'

gem 'jeremymcanally-pending', '>= 0.1'
require 'pending'

base = File.dirname(__FILE__)
Dir.glob(base + '/lib/*.rb'       ).each { |f| require f }
Dir.glob(base + '/test_cases/*.rb').each { |f| require f }
Dir.glob(base + '/assertions/*.rb').each { |f| require f }
Dir.glob(base + '/shared/*.rb'    ).each { |f| require f }

require File.dirname(__FILE__) + '/../../config/config'
Config.environment = 'test'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end

# If you use `rake test` the database will automatically get dropped.
# But if you are running inside TextMate, it is handy to automatically drop the
# database here:
if ENV["TM_APP_PATH"]
  puts "TextMate environment detected. Dropping test database..."
  Config.drop_database
end
