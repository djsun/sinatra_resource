module SinatraResource

  class Builder
    
    FILTER_KEY = "filter"
    SEARCH_KEY = "search"

    ITEMS_PER_PAGE = 20
    
    def initialize(klass)
      @klass  = klass

      @resource_config = @klass.resource_config
      @child_assoc     = @resource_config[:child_assoc]
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
          role = role_for(model, id)
          document = document_for_get_one(role, model, resource_config, true, id, nil, nil)
          resource = build_resource(role, document, resource_config)
          display(:read, resource, resource_config)
        end
      else
        child_assoc            = @child_assoc
        parent_model           = @parent_model
        parent_resource_config = @parent_resource_config
        path                   = @path
        @parent.get "/:parent_id/#{path}/:id/?" do
          id = params.delete("id")
          parent_id = params.delete("parent_id")
          parent_role = role_for(parent_model, parent_id)
          parent_document = document_for_get_one(parent_role, parent_model, parent_resource_config, false, parent_id, nil, nil)
          # ------
          role = role_for_nested(parent_document, child_assoc, model, id)
          document = document_for_get_one(role, model, resource_config, true, id, parent_document, child_assoc)
          resource = build_resource(role, document, resource_config)
          display(:read, resource, resource_config, parent_id)
        end
      end
    end

    def build_get_many
      model           = @model
      resource_config = @resource_config
      if !@parent
        @klass.get '/?' do
          role = lookup_role(nil)
          page = get_page(params)
          documents = log_time("#{model} documents_for_get_many") do
            documents_for_get_many(role, model, resource_config, page, ITEMS_PER_PAGE, true, nil, nil)
          end
          document_count = document_count_for_get_many(model, resource_config, nil, nil)
          page_count = calculate_page_count(document_count, ITEMS_PER_PAGE)
          resources = log_time("#{model} build_resources") do
            build_resources(documents, resource_config, page, page_count, document_count, ITEMS_PER_PAGE)
          end
          display(:list, resources, resource_config)
        end
      else
        child_assoc            = @child_assoc
        parent_model           = @parent_model
        parent_resource_config = @parent_resource_config
        path                   = @path
        @parent.get "/:parent_id/#{path}/?" do
          parent_id = params.delete("parent_id")
          parent_role = role_for(parent_model, parent_id)
          parent_document = document_for_get_one(parent_role, parent_model, parent_resource_config, false, parent_id, nil, nil)
          # ------
          role = lookup_role(nil)
          page = get_page(params)
          documents = documents_for_get_many(role, model, resource_config, page, ITEMS_PER_PAGE, true, parent_document, child_assoc)
          document_count = document_count_for_get_many(model, resource_config, parent_document, child_assoc)
          page_count = calculate_page_count(document_count, ITEMS_PER_PAGE)
          resources = build_resources(documents, resource_config, page, page_count, document_count, ITEMS_PER_PAGE)
          display(:list, resources, resource_config, parent_id)
        end
      end
    end
    
    def build_post
      model           = @model
      resource_config = @resource_config
      if !@parent
        @klass.post '/?' do
          role = lookup_role(nil)
          document = document_for_post(role, model, resource_config, true, nil, nil)
          resource = build_resource(role, document, resource_config)
          display(:create, resource, resource_config)
        end
      else
        child_assoc            = @child_assoc
        parent_model           = @parent_model
        parent_resource_config = @parent_resource_config
        path                   = @path
        @parent.post "/:parent_id/#{path}/?" do
          parent_id = params.delete("parent_id")
          parent_role = role_for(parent_model, parent_id)
          parent_document = document_for_get_one(parent_role, parent_model, parent_resource_config, false, parent_id, nil, nil)
          # ------
          role = lookup_role(nil)
          document = document_for_post(role, model, resource_config, true, parent_document, child_assoc)
          resource = build_resource(role, document, resource_config)
          display(:create, resource, resource_config, parent_id)
        end
      end
    end
    
    def build_put
      model           = @model
      resource_config = @resource_config
      if !@parent
        @klass.put '/:id/?' do
          id = params.delete("id")
          role = role_for(model, id)
          document = document_for_put(role, model, resource_config, true, id, nil, nil)
          resource = build_resource(role, document, resource_config)
          display(:update, resource, resource_config)
        end
      else
        child_assoc            = @child_assoc
        parent_model           = @parent_model
        parent_resource_config = @parent_resource_config
        path                   = @path
        @parent.put "/:parent_id/#{path}/:id/?" do
          id = params.delete("id")
          parent_id = params.delete("parent_id")
          parent_role = role_for(parent_model, parent_id)
          parent_document = document_for_get_one(parent_role, parent_model, parent_resource_config, false, parent_id, id, id)
          # ------
          role = role_for_nested(parent_document, child_assoc, model, id)
          document = document_for_put(role, model, resource_config, true, id, parent_document, child_assoc)
          resource = build_resource(role, document, resource_config)
          display(:update, resource, resource_config, parent_id)
        end
      end
    end
    
    def build_delete
      model           = @model
      resource_config = @resource_config
      if !@parent
        @klass.delete '/:id/?' do
          id = params.delete("id")
          role = role_for(model, id)
          document_for_delete(role, model, resource_config, true, id, nil, nil)
          display(:delete, "", resource_config)
        end
      else
        child_assoc            = @child_assoc
        parent_model           = @parent_model
        parent_resource_config = @parent_resource_config
        path                   = @path
        @parent.delete "/:parent_id/#{path}/:id/?" do
          id = params.delete("id")
          parent_id = params.delete("parent_id")
          parent_role = role_for(parent_model, parent_id)
          parent_document = document_for_get_one(parent_role, parent_model, parent_resource_config, false, parent_id, nil, nil)
          # ------
          role = role_for_nested(parent_document, child_assoc, model, id)
          document_for_delete(role, model, resource_config, true, id, parent_document, child_assoc)
          display(:delete, "", resource_config, parent_id)
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
