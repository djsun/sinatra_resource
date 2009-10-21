module SinatraResource
  
  class Builder

    module ActionDefinitions

      def document_for_get_one(role, id)
        check_permission(:read, role)
        check_params(:read, role)
        find_document!(id)
      end
      
      def documents_for_get_many(role)
        check_permission(:read, role)
        check_params(:read, role)
        find_documents!
      end
      
      def document_for_post(role)
        check_permission(:create, role)
        check_params(:create, role)
        create_document!
      end
      
      def document_for_put(role, id)
        check_permission(:update, role)
        check_params(:update, role)
        update_document!(id)
      end
      
      def document_for_delete(role, id)
        check_permission(:delete, role)
        check_params(:delete, role)
        delete_document!(id)
      end

    end
    
  end
  
end
