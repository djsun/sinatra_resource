module SinatraResource
  
  module Resource
    def self.included(includee)
      includee.extend ClassMethods
      includee.setup
    end
    
    def config
      self.class.instance_variable_get("@resource_config")
    end
    
    module ClassMethods
      
      # Build the Sinatra actions based on the DSL statements in this class.
      # You will want to do this last.
      #
      # If for some reason you reopen the class, you will need to call this
      # method again. However, this usage has not been tested.
      #
      # @return [undefined]
      #
      # @api public
      def build
        validate
        Builder.new(self).build
      end

      # Define some default properties to mirror common keys in the
      # model
      #
      # @return [undefined]
      #
      # @api private
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

      # Specify the underlying +model+
      #
      # @param [MongoMapper::Document] model
      #
      # @return [undefined]
      #
      # @api public
      def model(model)
        if @resource_config[:model]
          raise DefinitionError, "model already declared in #{self}"
        end
        @resource_config[:model] = model
        default_properties
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
      #
      # @api public
      def permission(access_rules)
        access_rules.each_pair do |verb, role|
          @resource_config[:permission][verb] = role
        end
      end
      
      # Declare a property and its access rules.
      #
      # @param [Symbol] name
      #
      # @param [Hash] access_rules
      #
      # @return [undefined]
      #
      # @api public
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
      # @param [Class] klass
      #
      # @return [undefined]
      #
      # @api public
      def roles(klass)
        if @resource_config[:roles]
          raise DefinitionError, "roles already declared in #{self}"
        end
        @resource_config[:roles] = klass
      end

      # For internal use. Initializes internal data structure.
      #
      # @api private
      def setup
        @resource_config = {
          :model      => nil,
          :permission => {},
          :properties => {},
          :roles      => nil,
        }
      end
      
      # Verifies correctness of resource.
      #
      # @raise [ValidationError] if invalid
      #
      # @return [undefined]
      #
      # @api private
      def validate
        unless @resource_config[:model]
          raise ValidationError, "model required"
        end
      end
      
    end
  end
  
end
