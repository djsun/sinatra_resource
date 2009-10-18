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
        role = check_permission(:read)
        id = params.delete("id")
        check_params(:read)
        document = find_document!(id)
        resource = build_resource(:read, role, document)
        display(resource)
      end
    end

    def build_get_many
      @klass.get '/?' do
        role = check_permission(:read)
        check_params(:read)
        documents = find_documents!
        # resources = build_resources(:read, role, documents)
        display(documents)
      end
    end
    
    def build_post
      @klass.post '/?' do
        role = check_permission(:create)
        check_params(:create)
        document = create_document!
        resource = build_resource(:read, role, document)
        display(resource)
      end
    end
    
    def build_put
      @klass.put '/:id/?' do
        check_permission(:update)
        id = params.delete("id")
        check_params(:update)
      end
    end
    
    def build_delete
      @klass.delete '/:id/?' do
        check_permission(:delete)
        id = params.delete("id")
        check_params(:delete)
      end
    end
    
    def build_helpers
      @klass.helpers do
        include Helpers
      end
    end
    
  end
  
end
