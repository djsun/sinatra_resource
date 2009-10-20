ENV['RACK_ENV'] = "development"
require 'app'

map("/categories") { run DataCatalog::Categories }
map("/sources")    { run DataCatalog::Sources }
map("/users")      { run DataCatalog::Users }
