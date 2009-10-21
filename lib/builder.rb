module SinatraResource

  class Builder
    
    def initialize(klass)
      @klass  = klass
      @parent = @klass.config[:parent] # class
      @simple = !@parent
      @path   = @klass.config[:path]
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
      if @simple
        @klass.get '/:id/?' do
          id = params.delete("id")
          role = get_role(id)
          document = document_for_get_one(role, id)
          resource = build_resource(role, document)
          display(:read, resource)
        end
      else
        @klass.get "/:parent_id/#{path}/:id/?" do
          parent_id = params.delete("parent_id")
          parent_role = get_role(parent_id)
          parent_document = document_for_get_one(parent_role, parent_id)
          # ---
          id = params.delete("id")
          role = get_role(id)
          document = document_for_get_one(role, id)
          resource = build_resource(role, document)
          display(:read, resource)
        end
      end
    end

    def build_get_many
      if @simple
        @klass.get '/?' do
          role = get_role
          documents = documents_for_get_many(role)
          resources = build_resources(documents)
          display(:read, resources)
        end
      end
    end
    
    def build_post
      if @simple
        @klass.post '/?' do
          role = get_role
          document = document_for_post(role)
          resource = build_resource(role, document)
          display(:create, resource)
        end
      end
    end
    
    def build_put
      if @simple
        @klass.put '/:id/?' do
          id = params.delete("id")
          role = get_role(id)
          document = document_for_put(role, id)
          resource = build_resource(role, document)
          display(:update, resource)
        end
      end
    end
    
    def build_delete
      if @simple
        @klass.delete '/:id/?' do
          id = params.delete("id")
          role = get_role(id)
          document_for_delete(role, id)
          display(:delete, "")
        end
      end
    end
    
    def build_helpers
      @klass.helpers do
        include ActionDefinitions
        include Helpers
        include MongoHelpers
      end
    end
    
  end
  
end
