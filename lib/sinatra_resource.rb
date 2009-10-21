base = File.dirname(__FILE__)
require base + '/exceptions'
Dir.glob(base + '/builder/*.rb').each { |f| require f }
require base + '/builder'
require base + '/resource'
require base + '/roles'