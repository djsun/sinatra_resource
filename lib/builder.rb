module SinatraResource

  class Builder
    
    def initialize(klass)
      @klass = klass
    end
    
    def build
      build_get_one
      build_get_many
      build_post
      build_put
      build_delete
      build_helpers
    end
    
    def build_get_one
      @klass.get '/:id/?' do
        basic_get_one
      end
    end

    def build_get_many
      @klass.get '/?' do
        basic_get_many
      end
    end
    
    def build_post
      @klass.post '/?' do
        basic_post
      end
    end
    
    def build_put
      @klass.put '/:id/?' do
        basic_put
      end
    end
    
    def build_delete
      @klass.delete '/:id/?' do
        basic_delete
      end
    end
    
    def build_helpers
      @klass.helpers do
        include ActionDefinitions
        include Helpers
        include MongoHelpers
      end
    end
    
  end
  
end
