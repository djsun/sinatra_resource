require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sinatra_resource"
    gem.summary = %Q{RESTful actions with Sinatra and MongoMapper}
    gem.description = %Q{A DSL for creating RESTful actions with Sinatra and MongoMapper. It embraces the Resource Oriented Architecture as explained by Leonard Richardson and Sam Ruby.}
    gem.email = "djames@sunlightfoundation.com"
    gem.homepage = "http://github.com/djsun/sinatra_resource"
    gem.authors = ["David James"]
    gem.add_development_dependency 'rspec'
    gem.add_development_dependency 'yard'
    # gem is a Gem::Specification ...
    # ... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install with: gem install jeweler"
end

task :default => :spec

Dir.glob(File.dirname(__FILE__) + '/tasks/*.rake').each { |f| load f }
