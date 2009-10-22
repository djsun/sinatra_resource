module SinatraResource
  
  class Builder

    module ActionDefinitions

      def document_for_get_one(role, model, resource_config, leaf, id)
        check_permission(:read, role, resource_config)
        check_params(:read, role, resource_config, leaf)
        find_document!(model, id)
      end
      
      def documents_for_get_many(role, model, resource_config, leaf)
        check_permission(:read, role, resource_config)
        check_params(:read, role, resource_config, leaf)
        find_documents!(model)
      end
      
      def document_for_post(role, model, resource_config, leaf)
        check_permission(:create, role, resource_config)
        check_params(:create, role, resource_config, leaf)
        create_document!(model)
      end
      
      def document_for_put(role, model, resource_config, leaf, id)
        check_permission(:update, role, resource_config)
        check_params(:update, role, resource_config, leaf)
        update_document!(model, id)
      end
      
      def document_for_delete(role, model, resource_config, leaf, id)
        check_permission(:delete, role, resource_config)
        check_params(:delete, role, resource_config, leaf)
        delete_document!(model, id)
      end

    end
    
  end
  
end
