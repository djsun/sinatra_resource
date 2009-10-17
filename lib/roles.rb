module SinatraResource

  module Roles
    def self.included(includee)
      includee.extend ClassMethods
    end
    
    module ClassMethods
      def role(*args)
        # TODO
      end
    end
  end
  
end
