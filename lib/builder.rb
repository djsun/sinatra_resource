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
        role = lookup_role
        check_permission(:read, role)
        id = params.delete("id")
        check_params(:read, role)
        document = find_document!(id)
        resource = build_resource(:read, role, document)
        display(resource)
      end
    end

    def build_get_many
      @klass.get '/?' do
        role = lookup_role
        check_permission(:read, role)
        check_params(:read, role)
        documents = find_documents!
        # resources = build_resources(:read, role, documents)
        display(documents)
      end
    end
    
    def build_post
      @klass.post '/?' do
        role = lookup_role
        check_permission(:create, role)
        check_params(:create, role)
        document = create_document!
        resource = build_resource(:read, role, document)
        display(resource)
      end
    end
    
    def build_put
      @klass.put '/:id/?' do
        role = lookup_role
        check_permission(:update, role)
        check_params(:update, role)
        id = params.delete("id")
        check_params(:update, role)
      end
    end
    
    def build_delete
      @klass.delete '/:id/?' do
        role = check_permission(:delete)
        id = params.delete("id")
        check_params(:delete, role)
      end
    end
    
    def build_helpers
      @klass.helpers do
        include Helpers
      end
    end
    
  end
  
end
