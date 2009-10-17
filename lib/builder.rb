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
    end
    
    def build_get_one
      @klass.get '/:id/?' do
      end
    end

    def build_get_many
      @klass.get '/?' do
      end
    end
    
    def build_post
      @klass.post '/?' do
      end
    end
    
    def build_put
      @klass.put '/:id/?' do
      end
    end
    
    def build_delete
      @klass.delete '/:id/?' do
      end
    end
    
  end
  
end
