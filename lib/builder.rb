module SinatraResource

  class Builder
    
    def initialize(klass)
      @klass  = klass

      @resource_config = @klass.resource_config
      @model           = @resource_config[:model]
      @parent          = @resource_config[:parent]
      @path            = @resource_config[:path]
      if @parent
        @parent_resource_config = @parent.resource_config
        @parent_model           = @parent_resource_config[:model]
      end
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
      model           = @model
      resource_config = @resource_config
      if !@parent
        @klass.get '/:id/?' do
          id = params.delete("id")
          role = get_role(model, id)
          document = document_for_get_one(role, model, resource_config, id)
          resource = build_resource(role, document, resource_config)
          display(:read, resource)
        end
      else
        parent_model           = @parent_model
        parent_resource_config = @parent_resource_config
        path                   = @path
        @parent.get "/:parent_id/#{path}/:id/?" do
          parent_id = params.delete("parent_id")
          id = params.delete("id")
          parent_role = get_role(parent_model, parent_id)
          parent_document = document_for_get_one(parent_role, parent_model, parent_resource_config, parent_id)
          # ------
          role = get_role(model, id)
          document = document_for_get_one(role, model, resource_config, id)
          unless parent_document.sources.include?(document)
            error 404, convert(body_for(:not_found))
          end
          document.xxxx == parent_document
          resource = build_resource(role, document, resource_config)
          display(:read, resource)
        end
      end
    end

    def build_get_many
      model           = @model
      resource_config = @resource_config
      if !@parent
        @klass.get '/?' do
          role = get_role(model)
          documents = documents_for_get_many(role, model, resource_config)
          resources = build_resources(documents, resource_config)
          display(:read, resources)
        end
      else
        parent_model           = @parent_model
        parent_resource_config = @parent_resource_config
        path                   = @path
        @parent.get "/:parent_id/#{path}/?" do
          parent_id = params.delete("parent_id")
          parent_role = get_role(parent_model, parent_id)
          parent_document = document_for_get_one(parent_role, parent_model, parent_resource_config, parent_id)
          # ------
          role = get_role(model)
          documents = documents_for_get_many(role, model, resource_config)
          resources = build_resources(documents, resource_config)
          display(:read, resources)
        end
      end
    end
    
    def build_post
      model           = @model
      resource_config = @resource_config
      if !@parent
        @klass.post '/?' do
          role = get_role(model)
          document = document_for_post(role, model, resource_config)
          resource = build_resource(role, document, resource_config)
          display(:create, resource)
        end
      else
        parent_model           = @parent_model
        parent_resource_config = @parent_resource_config
        path                   = @path
        @parent.post "/:parent_id/#{path}/?" do
          parent_id = params.delete("parent_id")
          parent_role = get_role(parent_model, parent_id)
          parent_document = document_for_get_one(parent_role, parent_model, parent_resource_config, parent_id)
          # ------
          role = get_role(model)
          document = document_for_post(role, model, resource_config)
          resource = build_resource(role, document, resource_config)
          display(:create, resource)
        end
      end
    end
    
    def build_put
      model           = @model
      resource_config = @resource_config
      if !@parent
        @klass.put '/:id/?' do
          id = params.delete("id")
          role = get_role(model, id)
          document = document_for_put(role, model, resource_config, id)
          resource = build_resource(role, document, resource_config)
          display(:update, resource)
        end
      else
        parent_model           = @parent_model
        parent_resource_config = @parent_resource_config
        path                   = @path
        @parent.put "/:parent_id/#{path}/:id/?" do
          id = params.delete("id")
          parent_id = params.delete("parent_id")
          parent_role = get_role(parent_model, parent_id)
          parent_document = document_for_get_one(parent_role, parent_model, parent_resource_config, parent_id)
          # ------
          role = get_role(model, id)
          document = document_for_put(role, model, resource_config, id)
          resource = build_resource(role, document, resource_config)
          display(:update, resource)
        end
      end
    end
    
    def build_delete
      model           = @model
      resource_config = @resource_config
      if !@parent
        @klass.delete '/:id/?' do
          id = params.delete("id")
          role = get_role(model, id)
          document_for_delete(role, model, resource_config, id)
          display(:delete, "")
        end
      else
        parent_model           = @parent_model
        parent_resource_config = @parent_resource_config
        path                   = @path
        @parent.delete "/:parent_id/#{path}/:id/?" do
          id = params.delete("id")
          parent_id = params.delete("parent_id")
          parent_role = get_role(parent_model, parent_id)
          parent_document = document_for_get_one(parent_role, parent_model, parent_resource_config, parent_id)
          # ------
          role = get_role(model, id)
          document_for_delete(role, model, resource_config, id)
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
