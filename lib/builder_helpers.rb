module SinatraResource
  
  class Builder

    module Helpers
      
      def check_params(action)
        
      end

      def check_permission(action)
        # puts "\n== check_permission(#{action.inspect})"
        role = lookup_role
        if role == :anonymous && minimum_role(action) != :anonymous
          missing_api_key!
        end
        # puts "   role : #{role.inspect}"
        invalid_api_key! unless role
        unauthorized_api_key! unless authorized?(role, action)
      end

      def authorized?(role, action)
        klass = config[:roles]
        klass.satisfies?(role, minimum_role(action))
      end

      def minimum_role(action)
        rom = read_or_modify?(action)
        config[:permission][rom]
      end

      def read_or_modify?(role)
        case role
        when :read
          :read
        when :create
          :modify
        when :update
          :modify
        when :delete
          :modify
        else
          raise "Unexpected role : #{role.inspect}"
        end
      end

    end

  end

end
