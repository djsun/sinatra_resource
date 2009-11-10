ENV['RACK_ENV'] = "development"
require 'app'

map("/categories") { run DataCatalog::Categories }
map("/notes")      { run DataCatalog::Notes }
map("/sources")    { run DataCatalog::Sources }
map("/users")      { run DataCatalog::Users }
