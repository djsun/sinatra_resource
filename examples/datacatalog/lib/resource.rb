require File.dirname(__FILE__) + '/../../../lib/sinatra_resource'

# However, in a stand-alone application, use:
# gem 'resource_sinatra', '>= 0.5.0', '< 0.6.0'
# require 'resource_sinatra'

module DataCatalog

  module Resource
    include SinatraResource::Resource

    def self.included(includee)
      includee.extend SinatraResource::Resource::ClassMethods
    end
  end

end
