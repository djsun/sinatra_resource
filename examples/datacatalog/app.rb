require 'rubygems'

gem 'sinatra', '>= 0.9.4'
require 'sinatra/base'

require File.dirname(__FILE__) + '/config/config'

Sinatra::Base.set(:config, Config.environment_config)
Config.setup

base = File.dirname(__FILE__)
# Dir.glob(base + '/lib/*.rb'      ).each { |f| require f }
Dir.glob(base + '/models/*.rb'   ).each { |f| require f }
# Dir.glob(base + '/resources/*.rb').each { |f| require f }
