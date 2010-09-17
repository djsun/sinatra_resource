require 'rubygems'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sinatra_resource"
    gem.summary = %Q{RESTful actions with Sinatra and MongoMapper}
    gem.description = %Q{A DSL for creating RESTful actions with Sinatra and MongoMapper. It embraces the Resource Oriented Architecture as explained by Leonard Richardson and Sam Ruby.}
    gem.email = "djames@sunlightfoundation.com"
    gem.homepage = "http://github.com/sunlightlabs/sinatra_resource"
    gem.authors = ["David James"]

    gem.add_dependency 'activesupport', '~> 3.0.0'
    # gem.add_dependency 'bson', '~> 1.0.7'
    # gem.add_dependency 'bson_ext', '~> 1.0.7'
    gem.add_dependency 'frequency', '~> 0.1.5'
    gem.add_dependency 'kronos', '~> 0.1.7'
    gem.add_dependency 'i18n', '~> 0.4.1'
    gem.add_dependency 'mongo_mapper', '~> 0.8.4'
    gem.add_dependency 'query_string_filter', '~> 0.1.6'
    gem.add_dependency 'sinatra', '~> 1.0.0'

    gem.add_development_dependency 'crack', '~> 0.1.4'
    gem.add_development_dependency 'pending', '~> 0.1.1'
    gem.add_development_dependency 'rake', '~> 0.8.7'
    gem.add_development_dependency 'rcov', '~> 0.9.8'
    gem.add_development_dependency 'rr', '~> 1.0.0'
    gem.add_development_dependency 'rspec', '~> 1.3.0'
    gem.add_development_dependency 'timecop', '~> 0.3.5'
    gem.add_development_dependency 'tu-context', '~> 0.5.8'
    gem.add_development_dependency 'yard', '~> 0.6.1'

    # gem is a Gem::Specification ...
    # ... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install with: gem install jeweler"
end

task :default => :spec

Dir.glob(File.dirname(__FILE__) + '/tasks/*.rake').each { |f| load f }
