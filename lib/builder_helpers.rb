module SinatraResource
  
  class Builder

    module Helpers
      
      def check_params(action)
        
      end

      # Check to see if the current role has permission for the specified
      # action.
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
        klass.satisfies?(role, minimum_role(action))
      end
    
      # Return the minimum role required for a given action.
      #
      # @param [Symbol] action
      #   :read, :create, :update, or :delete
      #
      # @return [Symbol]
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @api semipublic
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
