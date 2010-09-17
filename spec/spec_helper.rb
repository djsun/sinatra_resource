require 'rubygems'
begin
  require 'bundler'
  Bundler.setup
rescue LoadError
  puts "Please run `gem install bundler` and `bundle install`"
end
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|

end
