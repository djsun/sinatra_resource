module SinatraResource

  class Builder
    
    def initialize(klass)
      @klass = klass
    end
    
    def build
      build_get_one
      build_get_many
      build_post
      build_put
      build_delete
      build_helpers
    end
    
    def build_get_one
      @klass.get '/:id/?' do
        id = params.delete("id")
        role = get_role(id)
        check_permission(:read, role)
        check_params(:read, role)
        document = find_document!(id)
        resource = build_resource(role, document)
        display(resource)
      end
    end

    def build_get_many
      @klass.get '/?' do
        role = get_role
        check_permission(:read, role)
        check_params(:read, role)
        documents = find_documents!
        resources = build_resources(documents)
        display(resources)
      end
    end
    
    def build_post
      @klass.post '/?' do
        role = get_role
        check_permission(:create, role)
        check_params(:create, role)
        document = create_document!
        resource = build_resource(role, document)
        display(resource)
      end
    end
    
    def build_put
      @klass.put '/:id/?' do
        id = params.delete("id")
        role = get_role(id)
        check_permission(:update, role)
        check_params(:update, role)
        document = update_document!(id)
        resource = build_resource(role, document)
        display(resource)
      end
    end
    
    def build_delete
      @klass.delete '/:id/?' do
        id = params.delete("id")
        role = get_role(id)
        check_permission(:delete)
        check_params(:delete, role)
        # status code?
      end
    end
    
    def build_helpers
      @klass.helpers do
        include Helpers
        include MongoHelpers
      end
    end
    
  end
  
end
