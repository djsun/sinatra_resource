base = File.dirname(__FILE__)
require base + '/utility'
require base + '/exceptions'
require base + '/builder'
Dir.glob(base + '/builder/*.rb').each { |f| require f }
require base + '/resource'
require base + '/roles'
