require File.dirname(__FILE__) + '/test_helper'

Config.setup_mongomapper
base = File.dirname(__FILE__)
Dir.glob(base + '/../../models/*.rb'       ).each { |f| require f }

require File.dirname(__FILE__) + '/model_factories'
include ModelFactories
