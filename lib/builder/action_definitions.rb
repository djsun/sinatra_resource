module SinatraResource
  
  class Builder

    module ActionDefinitions

      def document_for_get_one(role, model, resource_config, leaf, id, parent_document, association)
        check_permission(:read, role, resource_config)
        if resource_config[:parent]
          check_related?(parent_document, association, id)
        end
        check_params(:read, role, resource_config, leaf)
        find_document!(model, id)
      end
      
      def documents_for_get_many(role, model, resource_config, leaf, parent_document, association)
        check_permission(:read, role, resource_config)
        check_params(:read, role, resource_config, leaf)
        documents = find_documents!(model)
        # TODO: A more performant approach would be to modify find_documents!
        # so that it returns the correct results in one query.
        if resource_config[:parent]
          documents = select_related(parent_document, association, documents)
        end
        documents
      end
      
      def document_for_post(role, model, resource_config, leaf, parent_document, association)
        check_permission(:create, role, resource_config)
        check_params(:create, role, resource_config, leaf)
        document = create_document!(model)
        if resource_config[:parent]
          make_related(parent_document, document, resource_config)
        end
        document
      end
      
      def document_for_put(role, model, resource_config, leaf, id, parent_document, association)
        check_permission(:update, role, resource_config)
        if resource_config[:parent]
          check_related?(parent_document, association, id)
        end
        check_params(:update, role, resource_config, leaf)
        update_document!(model, id)
      end
      
      def document_for_delete(role, model, resource_config, leaf, id, parent_document, association)
        check_permission(:delete, role, resource_config)
        if resource_config[:parent]
          check_related?(parent_document, association, id)
        end
        check_params(:delete, role, resource_config, leaf)
        delete_document!(model, id)
      end

    end
    
  end
  
end
