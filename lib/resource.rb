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
      def setup
        @resource_config = {
          :model      => nil,
          :permission => {},
          :properties => {},
          :roles      => nil,
        }
      end
      
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

      def model(name)
        if @resource_config[:model]
          raise DefinitionError, "model already declared in #{self}"
        end
        @resource_config[:model] = name
        default_properties
      end
      
      def permission(access_rules)
        access_rules.each_pair do |verb, role|
          @resource_config[:permission][verb] = role
        end
      end
      
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
      
      def roles(klass)
        if @resource_config[:roles]
          raise DefinitionError, "roles already declared in #{self}"
        end
        @resource_config[:roles] = klass
      end
      
      def build
        validate
        Builder.new(self).build
      end

      def validate
        unless @resource_config[:model]
          raise ValidationError, "model required"
        end
      end
      
    end
  end
  
end
