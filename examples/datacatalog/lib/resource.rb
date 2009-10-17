module DataCatalog
  
  module Resource
    include SinatraResource::Resource

    def self.included(includee)
      includee.extend SinatraResource::Resource::ClassMethods
    end

    # TODO
  end
  
end
