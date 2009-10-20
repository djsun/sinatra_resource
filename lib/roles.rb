module SinatraResource

  module Roles
    def self.included(includee)
      includee.extend ClassMethods
      includee.setup
    end
    
    module ClassMethods

      # High-level way to define a role. You can also specify what role it
      # builds upon (its parent).
      #
      # For example:
      #   role :anonymous
      #   role :basic => :anonymous
      #   role :admin => :basic
      #
      # This means: admin > basic > anonymous
      #
      # The order of the role statements does not matter. Only the
      # dependencies between a role and its parent are significant.
      #
      # Roles do not have to be a single linear ordering. You can have any
      # number of roles, connected in a DAG (directed acyclic graph). For
      # example:
      #
      #   role :anonymous
      #   role :basic   => :anonymous
      #   role :editor  => :basic
      #   role :manager => :basic
      #   role :admin   => [:editor, :manager]
      #
      #   # which means:
      #   # * admin > manager > basic > anonymous
      #   # * admin > editor  > basic > anonymous
      #   # * manager and editor cannot be compared
      #
      # @param [Symbol, Hash<Symbol => [Symbol, Array<Symbol>]>] arg
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

      # Is +role+ at least as privileged as +minimum+?
      #
      # @example
      #   satisfies?(:anonymous, :basic) # => false
      #   satisfies?(:admin,     :basic) # => true
      #   satisfies?(:basic,     :basic) # => true
      #
      # @param [Symbol] role
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @param [Symbol] minimum
      #
      # @return [Boolean]
      def satisfies?(role, minimum)
        @satisfies_cache[[role, minimum]] ||= (
          role == minimum || ancestors(role).include?(minimum)
        )
      end

      def setup
        @role_config = {}
        @satisfies_cache = {}
      end

      # Halt if +role+ is undefined.
      #
      # @raise [UndefinedRole] if role undefined
      def validate_role(role)
        unless @role_config.include?(role)
          raise UndefinedRole, "#{role.inspect} not defined"
        end
      end

      protected

      # Find the ancestors of +role+.
      #
      # @param [Symbol] role
      #
      # @return [Array<Symbol>]
      def ancestors(role)
        _ancestors([role])
      end

      # Find the ancestors of +roles+.
      #
      # Implementation details
      #
      # This is a recursive function. For each recursion, all of the parents
      # of the list are found. A new list is created by merging the original
      # list and the parents. The recursion stops when the new list is the
      # same as the original list.
      #
      # If you have these roles ...
      #   role :anonymous
      #   role :basic   => :anonymous
      #   role :owner   => :basic
      #   role :curator => :basic
      #   role :admin   => [:owner, :curator]
      #
      # ... and you do ...
      #   _ancestors([:owner, :curator])
      #
      # ... then the recursion unfolds like this:
      #   _ancestors([:owner, :curator, :basic])
      #   _ancestors([:owner, :curator, :basic, :anonymous])
      #
      # @param [Array<Symbol>] roles
      #
      # @return [Array<Symbol>]
      def _ancestors(roles)
        parents = roles.map { |role| parents(role) }.flatten
        list = parents.concat(roles).uniq
        return roles if list == roles
        _ancestors(list)
      end

      # Low-level way to define a role. You can also specify what role it
      # builds upon (+parent_name+).
      #
      # @param [Symbol] name
      #   The name of the role being defined
      #
      # @param [Symbol, nil] parent_name
      #   The name of the parent role
      #
      # @api private
      def create_role(name, parent_name=nil)
        @role_config[name] = parent_name
      end

      # Find the parents of +role+.
      #
      # @param [Symbol] role
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @return [Array<Symbol>]
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
