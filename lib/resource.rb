module SinatraResource
  
  module Resource
    def self.included(includee)
      includee.extend ClassMethods
    end
    
    module ClassMethods
      def model(*args)
      end
      
      def permission(*args)
      end
      
      def property(*args)
      end
    end
  end
  
end
