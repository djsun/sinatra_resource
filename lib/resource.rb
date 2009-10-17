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

      def model(*args)
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
        Builder.new(self).build
      end
    end
  end
  
end
