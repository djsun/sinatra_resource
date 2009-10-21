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
      
      # Build the Sinatra actions based on the DSL statements in this class.
      # You will want to do this last.
      #
      # If for some reason you reopen the class, you will need to call this
      # method again. However, this usage has not been tested.
      #
      # @return [undefined]
      def build
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
        default_properties
      end
      
      # Specify the parent +resource+. Only used for nested resources.
      #
      # @param [Class] resource
      #
      # @return [undefined]
      def parent(resource)
        @resource_config[:parent] = resource
        # TODO...
        # resource_config[:path]
        # resource_config[:route_prefix]
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
        @resource_config[:path] = name
      end
      
      # Specify the minimal role needed to access this resource for reading
      # or writing.
      #
      # @example
      #   permission :read   => :basic
      #   permission :modify => :owner
      #
      # @param [Hash<Symbol => Symbol>] access_rules
      #   valid keys are :read or :modify
      #   values should be a role (such as :admin)
      #
      # @return [undefined]
      def permission(access_rules)
        access_rules.each_pair do |verb, role|
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
          raise DefinitionError, "property #{name} already declared in #{self}"
        end
        @resource_config[:properties][name] = {}
        if block
          @resource_config[:properties][name][:w] = :nobody
          @resource_config[:properties][name][:read_proc] = block
        else
          access_rules.each_pair do |kind, role|
            @resource_config[:properties][name][kind] = role
          end
        end
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
          :model      => nil,
          :permission => {},
          :properties => {},
          :roles      => nil,
          :parent     => nil,
          :path       => default_path,
        }
      end
      
      protected
      
      # Return the default relative path for a resource.
      #
      # @return [String]
      def default_path
        self.to_s.split('::').last.downcase
      end

      # Define some default properties to mirror common keys in the
      # model
      #
      # @return [undefined]
      def default_properties
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
