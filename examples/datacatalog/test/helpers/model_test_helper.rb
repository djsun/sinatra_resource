require File.dirname(__FILE__) + '/test_helper'

Config.setup_mongomapper
base = File.dirname(__FILE__)
Dir.glob(base + '/../../model_helpers/*.rb').each { |f| require f }
Dir.glob(base + '/../../models/*.rb').each { |f| require f }
