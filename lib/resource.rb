module SinatraResource
  
  module Resource
    def self.included(includee)
      includee.extend ClassMethods
      includee.setup
    end
    
    module ClassMethods
      def setup
        @resource_config = {
          :model      => nil,
          :permission => {},
          :property   => {},
        }
      end

      def model(name)
        @resource_config[:model] = name
      end
      
      def permission(access_rules)
        access_rules.each_pair do |verb, role|
          @resource_config[:permission][verb] = role
        end
      end
      
      def property(name, access_rules={})
        access_rules.each_pair do |kind, role|
          @resource_config[:property][name] ||= {}
          @resource_config[:property][name][kind] = role
        end
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
