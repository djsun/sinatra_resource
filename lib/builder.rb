module SinatraResource

  class Builder
    
    def initialize(klass)
      @klass  = klass

      config = @klass.resource_config
      @parent = config[:parent]
      @simple = !@parent
      @path   = config[:path]
      @model  = config[:model]
      @parent_model = @model # FIXME!!!
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
      model, path, parent_model = @model, @path, @parent_model
      if @simple
        @klass.get '/:id/?' do
          id = params.delete("id")
          role = get_role(model, id)
          document = document_for_get_one(role, model, id)
          resource = build_resource(role, document)
          display(:read, resource)
        end
      else
        @klass.get "/:parent_id/#{path}/:id/?" do
          parent_id = params.delete("parent_id")
          parent_role = get_role(parent_model, parent_id)
          parent_document = document_for_get_one(parent_role, parent_model, parent_id)
          # ---
          id = params.delete("id")
          role = get_role(model, id)
          document = document_for_get_one(role, model, id)
          resource = build_resource(role, document)
          display(:read, resource)
        end
      end
    end

    def build_get_many
      model, path, parent_model = @model, @path, @parent_model
      if @simple
        @klass.get '/?' do
          role = get_role(model)
          documents = documents_for_get_many(role, model)
          resources = build_resources(documents)
          display(:read, resources)
        end
      end
    end
    
    def build_post
      model, path, parent_model = @model, @path, @parent_model
      if @simple
        @klass.post '/?' do
          role = get_role(model)
          document = document_for_post(role, model)
          resource = build_resource(role, document)
          display(:create, resource)
        end
      end
    end
    
    def build_put
      model, path, parent_model = @model, @path, @parent_model
      if @simple
        @klass.put '/:id/?' do
          id = params.delete("id")
          role = get_role(model, id)
          document = document_for_put(role, model, id)
          resource = build_resource(role, document)
          display(:update, resource)
        end
      end
    end
    
    def build_delete
      model, path, parent_model = @model, @path, @parent_model
      if @simple
        @klass.delete '/:id/?' do
          id = params.delete("id")
          role = get_role(model, id)
          document_for_delete(role, model, id)
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
