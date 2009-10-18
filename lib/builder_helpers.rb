module SinatraResource
  
  class Builder

    module Helpers

      # Is the role authorized for the action?
      #
      # @param [Symbol] role
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @param [Symbol] action
      #   :read, :create, :update, or :delete
      #
      # @return [Boolean]
      #
      # @api private
      def authorized?(role, action)
        klass = config[:roles]
        r = nil
        10_000.times do
          r = klass.satisfies?(role, minimum_role(action))
        end
        r
      end
      
      # Default body message for a situation
      #
      # @param [Symbol] situation
      #
      # @return [String]
      #
      # @api public
      def body_for(situation)
        case situation
        when :internal_server_error
          nil
        when :invalid_document
          nil
        when :not_found
          nil
        when :unauthorized
          nil
        end
      end
      
      # Halt unless the current params are ok for the action
      #
      # @param [Symbol] action
      #   :read, :create, :update, or :delete
      #
      # @return [undefined]
      #
      # @api public
      def check_params(action)
        # TODO
      end

      # Halt unless the current role has permission to carry out the action
      #
      # @param [Symbol] action
      #   :read, :create, :update, or :delete
      #
      # @return [undefined]
      #
      # @api public
      def check_permission(action)
        role = lookup_role
        before_authorization(role, action)
        unauthorized! unless authorized?(role, action)
      end
      
      # Convert object to appropriate format, such as JSON or XML
      # 
      # @param [Object]
      #
      # @return [String]
      #
      # @api public
      def display(object)
        # raise NotImplemented
        object.nil? ? nil : object.to_json
      end

      # Find a document by id. Calls not_found! if needed, which probably
      # should cause a 404 Not Found status code to be returned.
      #
      # @param [Class] model
      #   a class that includes MongoMapper::Document
      #
      # @return [MongoMapper::Document]
      #
      # @api private
      def find_document!(model, id)
        document = model.find_by_id(id)
        unless document
          error 404, display(body_for(:not_found))
        end
        document
      end

      # Return the minimum role required for a given action.
      #
      # @param [Symbol] action
      #   :read, :create, :update, or :delete
      #
      # @return [Symbol]
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @api public
      def minimum_role(action)
        config[:permission][to_read_or_modify(action)]
      end

      # Convert from (:read, :create, :update, or :delete) to (:read or
      # :modify).
      #
      # @param [Symbol] action
      #   :read, :create, :update, or :delete
      #
      # @return [Symbol]
      #   :read or :modify
      #
      # @api private
      def to_read_or_modify(action)
        case action
        when :read   then :read
        when :create then :modify
        when :update then :modify
        when :delete then :modify
        else raise "Unexpected role : #{role.inspect}"
        end
      end

    end

  end

end
