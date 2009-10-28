module SinatraResource
  
  module Resource
    def self.included(includee)
      includee.extend ClassMethods
      includee.setup
    end
    
    def resource_config
      self.class.resource_config
    end

    module ClassMethods
      
      attr_reader :resource_config
      
      # Specify a callback.
      #
      # @param [Symbol] method
      #   A symbol that refers to a method on the parent.
      #
      # @return [undefined]
      def callback(name, &block)
        unless @resource_config[:callbacks].include?(name)
          raise DefinitionError, "callback #{name.inspect} is not supported #{self}"
        end
        if @resource_config[:callbacks][name]
          raise DefinitionError, "callback #{name.inspect} already declared in #{self}"
        end
        @resource_config[:callbacks][name] = block
      end
      
      # Specify the association +method+ on +parent+ that points to the
      # current (child) +model+.
      #
      # @param [Symbol] method
      #   A symbol that refers to a method on the parent.
      #
      # @return [undefined]
      def child_association(method)
        if @resource_config[:child_association]
          raise DefinitionError, "child_association already declared in #{self}"
        end
        @resource_config[:child_association] = method
      end
      
      # Build the Sinatra actions based on the DSL statements in this class.
      # You will want to do this last.
      #
      # If for some reason you reopen the class, you will need to call this
      # method again. However, this usage has not been tested.
      #
      # @return [undefined]
      def build
        deferred_defaults
        validate
        Builder.new(self).build
      end
      
      # Specify the underlying +model+
      #
      # @example
      #   model User
      #
      #   # which refers to, for example ...
      #   # class User
      #   #   include MongoMapper::Document
      #   #   ...
      #   # end
      #
      # @param [MongoMapper::Document] model
      #
      # @return [undefined]
      def model(model)
        if @resource_config[:model]
          raise DefinitionError, "model already declared in #{self}"
        end
        @resource_config[:model] = model
      end
      
      # Specify the parent +resource+. Only used for nested resources.
      #
      # @param [Class] resource
      #
      # @return [undefined]
      def parent(resource)
        if @resource_config[:parent]
          raise DefinitionError, "parent already declared in #{self}"
        end
        @resource_config[:parent] = resource
      end
      
      # Specify the path. If not specified, SinatraResource will infer the path
      # from the resource class (see the +default_path+ method.)
      #
      # This method is also useful for nested resources.
      #
      # @param [String] name
      #
      # @return [undefined]
      def path(name)
        if @resource_config[:path]
          raise DefinitionError, "path already declared in #{self}"
        end
        @resource_config[:path] = name
      end
      
      # Specify the minimal role needed to access this resource for reading
      # or writing.
      #
      # @example
      #   permission :list   => :basic
      #   permission :read   => :basic
      #   permission :create => :basic
      #   permission :update => :owner
      #   permission :delete => :owner
      #
      # @param [Hash<Symbol => Symbol>] access_rules
      #   valid keys are:
      #     :list, :read, :create, :update, :delete
      #   values should be a role (such as :admin)
      #
      # @return [undefined]
      def permission(access_rules)
        access_rules.each_pair do |verb, role|
          @resource_config[:roles].validate_role(role)
          @resource_config[:permission][verb] = role
        end
      end
      
      # Declare a property and its access rules.
      #
      # @example
      #   property :name,  :r => :basic
      #   property :email, :r => :owner
      #   property :role,  :r => :owner, :w => :admin
      #
      # @param [Symbol] name
      #
      # @param [Hash] access_rules
      #
      # @return [undefined]
      def property(name, access_rules={}, &block)
        if @resource_config[:properties][name]
          raise DefinitionError, "property #{name.inspect} already declared in #{self}"
        end
        @resource_config[:properties][name] = {}
        if block
          @resource_config[:properties][name][:w] = :nobody
          @resource_config[:properties][name][:read_proc] = block
        else
          access_rules.each_pair do |kind, role|
            @resource_config[:roles].validate_role(role)
            @resource_config[:properties][name][kind] = role
          end
        end
      end
      
      # Declare a relation with a block of code.
      #
      # Only needed with nested resources. 
      #
      # For example:
      #   relation :create do |parent, child|
      #     Categorization.create(
      #       :category_id => parent.id,
      #       :source_id   => child.id
      #     )
      #   end
      #
      # This runs after a POST to automatically connect parent with child.
      #
      # Is useful to create a document that joins a category (the parent)
      # to the source (the child).
      #
      # @param [Symbol] name
      #
      # @return [undefined]
      def relation(name, &block)
        if @resource_config[:relation][name]
          raise DefinitionError, "relation #{name.inspect} already declared in #{self}"
        end
        @resource_config[:relation][name] = block
      end
      
      # Specify the role definitions for this resource.
      #
      # @example
      #   roles Roles
      #   
      #   # which refers to, for example ...
      #   # module Roles
      #   #   include SinatraResource::Roles
      #   # 
      #   #   role :anonymous
      #   #   role :basic => :anonymous
      #   #   role :admin => :basic
      #   # end
      #
      # @param [Class] klass
      #
      # @return [undefined]
      def roles(klass)
        if @resource_config[:roles]
          raise DefinitionError, "roles already declared in #{self}"
        end
        @resource_config[:roles] = klass
      end

      # For internal use. Initializes internal data structure.
      def setup
        @resource_config = {
          :callbacks         => {
            :before_create   => nil,
            :after_create    => nil,
            :before_update   => nil,
            :after_update    => nil,
            :before_destroy  => nil,
            :after_destroy   => nil,
          },
          :child_association => nil,
          :model             => nil,
          :parent            => nil,
          :path              => nil, # default_path,
          :permission        => {},
          :properties        => {},
          :relation          => {
            :create          => nil,
            :delete          => nil,
          },
          :roles             => nil,
        }
      end
      
      protected
      
      # Set some defaults, only if they haven't been set already.
      #
      # @return [undefined]
      def deferred_defaults
        set_default_path
        set_default_properties
      end
      
      # Set the default relative path for a resource.
      #
      # @return [undefined]
      def set_default_path
        unless @resource_config[:path]
          @resource_config[:path] = self.to_s.split('::').last.downcase
        end
      end

      # Define some default properties to mirror common keys in the
      # model
      #
      # @return [undefined]
      def set_default_properties
        keys = @resource_config[:model].keys
        if keys.include?("_id")
          property :id, :w => :nobody
        end
        
        if keys.include?("created_at")
          property :created_at, :w => :nobody
        end

        if keys.include?("updated_at")
          property :updated_at, :w => :nobody
        end
      end
      
      # Verifies correctness of resource.
      #
      # @raise [ValidationError] if invalid
      #
      # @return [undefined]
      def validate
        unless @resource_config[:model]
          raise ValidationError, "model required"
        end
      end
      
    end
  end
  
end
