module SinatraResource

  module Roles
    def self.included(includee)
      includee.extend ClassMethods
      includee.setup
    end
    
    module ClassMethods
      def setup
        @role_config = {}
        @satisfies_cache = {}
      end
      
      def role(arg)
        if arg.is_a?(Symbol)
          create_role(arg)
        elsif arg.is_a?(Hash)
          arg.each_pair do |name, parent_name|
            create_role(name, parent_name)
          end
        else
          raise ArgumentError
        end
      end
      
      def create_role(name, parent_name=nil)
        @role_config[name] = parent_name
      end

      # Is +role+ as least as privileged as +minimum+?
      #
      # For example:
      #   satisfies?(:anonymous, :basic) # => false
      #   satisfies?(:admin,     :basic) # => true
      #   satisfies?(:basic,     :basic) # => true
      #
      # @param [Symbol] role
      #
      # @param [Symbol] minimum
      #
      # @return [Boolean]
      #
      # @api public
      def satisfies?(role, minimum)
        @satisfies_cache[[role, minimum]] ||= (
          role == minimum || ancestors(role).include?(minimum)
        )
      end
      
      def validate_role(role)
        unless @role_config.include?(role)
          raise UndefinedRole, "#{role.inspect} not defined"
        end
      end
      
      def _satisfies?(role, minimum_role)
      end
      
      # ancestors(:admin)
      def ancestors(role)
        _ancestors([role])
      end
      
      # _ancestors([:owner, :curator])
      # _ancestors([:owner, :curator, :basic, :basic])
      # _ancestors([:owner, :curator, :basic])
      # _ancestors([:owner, :curator, :basic, :anonymous])
      # _ancestors([:owner, :curator, :basic, :anonymous])
      def _ancestors(roles)
        parents = roles.map { |role| parents(role) }.flatten
        list = parents.concat(roles).uniq
        return roles if list == roles
        _ancestors(list)
      end
      
      def parents(role)
        x = @role_config[role]
        if x.is_a?(Enumerable)
          x
        elsif x
          [x]
        else
          []
        end
      end
    end
  end
  
end
