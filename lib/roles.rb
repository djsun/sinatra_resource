module SinatraResource

  module Roles
    def self.included(includee)
      includee.extend ClassMethods
      includee.setup
    end
    
    module ClassMethods
      def setup
        @role_config = {}
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

      # satisfies?(:admin,     :basic) # => true
      # satisfies?(:basic,     :basic) # => true
      # satisfies?(:anonymous, :basic) # => false
      def satisfies?(role, minimum_role)
        unless @role_config.include?(role)
          raise UndefinedRole, "#{role.inspect} not in list of defined roles " +
            "(#{@role_config.keys.inspect})"
        end
        role == minimum_role || ancestors(role).include?(minimum_role)
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
