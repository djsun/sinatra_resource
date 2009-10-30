module SinatraResource
  
  class Builder

    module ActionDefinitions

      def document_for_get_one(role, model, resource_config, leaf, id, parent_document, child_assoc)
        check_permission(:read, role, resource_config)
        if resource_config[:parent]
          check_related?(parent_document, child_assoc, id)
        end
        check_params(:read, role, resource_config, leaf)
        if resource_config[:parent]
          find_nested_document!(parent_document, child_assoc, model, id)
        else
          find_document!(model, id)
        end
      end
      
      def documents_for_get_many(role, model, resource_config, leaf, parent_document, child_assoc)
        check_permission(:list, role, resource_config)
        check_params(:list, role, resource_config, leaf)
        documents = if resource_config[:parent]
          find_nested_documents!(parent_document, child_assoc, model)
        else
          find_documents!(model)
        end
        documents.select do |doc|
          authorized?(:read, lookup_role(doc), resource_config)
        end
      end
      
      def document_for_post(role, model, resource_config, leaf, parent_document, child_assoc)
        check_permission(:create, role, resource_config)
        check_params(:create, role, resource_config, leaf)
        do_callback(:before_create, resource_config, nil)
        document = if resource_config[:parent]
          create_nested_document!(parent_document, child_assoc, model)
        else
          create_document!(model)
        end
        if resource_config[:parent]
          make_related(parent_document, document, resource_config)
        end
        do_callback(:after_create, resource_config, document)
        document
      end
      
      def document_for_put(role, model, resource_config, leaf, id, parent_document, child_assoc)
        check_permission(:update, role, resource_config)
        if resource_config[:parent]
          check_related?(parent_document, child_assoc, id)
        end
        check_params(:update, role, resource_config, leaf)
        document = if resource_config[:parent]
          find_nested_document!(parent_document, child_assoc, model, id)
        else
          find_document!(model, id)
        end
        do_callback(:before_update, resource_config, document)
        document = if resource_config[:parent]
          update_nested_document!(parent_document, child_assoc, model, id)
        else
          update_document!(model, id)
        end
        do_callback(:after_update, resource_config, document)
        document
      end
      
      def document_for_delete(role, model, resource_config, leaf, id, parent_document, child_assoc)
        check_permission(:delete, role, resource_config)
        if resource_config[:parent]
          check_related?(parent_document, child_assoc, id)
        end
        check_params(:delete, role, resource_config, leaf)
        document = if resource_config[:parent]
          find_nested_document!(parent_document, child_assoc, model, id)
        else
          find_document!(model, id)
        end
        do_callback(:before_destroy, resource_config, document)
        document = if resource_config[:parent]
          delete_nested_document!(parent_document, child_assoc, model, id)
        else
          delete_document!(model, id)
        end
        do_callback(:after_destroy, resource_config, document)
        document
      end

    end
    
  end
  
end
