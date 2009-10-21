module SinatraResource
  
  class Builder

    module ActionDefinitions

      def document_for_get_one(role, model, id)
        check_permission(:read, role)
        check_params(:read, role)
        find_document!(model, id)
      end
      
      def documents_for_get_many(role, model)
        check_permission(:read, role)
        check_params(:read, role)
        find_documents!(model)
      end
      
      def document_for_post(role, model)
        check_permission(:create, role)
        check_params(:create, role)
        create_document!(model)
      end
      
      def document_for_put(role, model, id)
        check_permission(:update, role)
        check_params(:update, role)
        update_document!(model, id)
      end
      
      def document_for_delete(role, model, id)
        check_permission(:delete, role)
        check_params(:delete, role)
        delete_document!(model, id)
      end

    end
    
  end
  
end
