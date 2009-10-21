module SinatraResource
  
  class Builder

    module ActionDefinitions

      def basic_get_one
        id = params.delete("id")
        role = get_role(id)
        check_permission(:read, role)
        check_params(:read, role)
        document = find_document!(id)
        resource = build_resource(role, document)
        display(:read, resource)
      end
      
      def basic_get_many
        role = get_role
        check_permission(:read, role)
        check_params(:read, role)
        documents = find_documents!
        resources = build_resources(documents)
        display(:read, resources)
      end
      
      def basic_post
        role = get_role
        check_permission(:create, role)
        check_params(:create, role)
        document = create_document!
        resource = build_resource(role, document)
        display(:create, resource)
      end
      
      def basic_put
        id = params.delete("id")
        role = get_role(id)
        check_permission(:update, role)
        check_params(:update, role)
        document = update_document!(id)
        resource = build_resource(role, document)
        display(:update, resource)
      end
      
      def basic_delete
        id = params.delete("id")
        role = get_role(id)
        check_permission(:delete, role)
        check_params(:delete, role)
        delete_document!(id)
        display(:delete, "")
      end

    end
    
  end
  
end
