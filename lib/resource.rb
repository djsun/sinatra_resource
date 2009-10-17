module SinatraResource
  
  module Resource
    def self.included(includee)
      puts "\n== includee : #{includee.inspect}"
      puts "   self : #{self.inspect}"
      includee.extend ClassMethods
      includee.setup
    end
    
    module ClassMethods
      def setup
        puts "\n== setup"
        puts "   self: #{self.inspect}"
        @resource_config = {
          :model      => nil,
          :permission => [],
          :property   => [],
        }
      end

      def model(*args)
      end
      
      def permission(hash)
        puts "\n== permission"
        puts @resource_config.inspect
      end
      
      def property(*args)
      end
      
      def build
        Builder.new(self).build
      end
    end
  end
  
end
