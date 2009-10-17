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
        check_permission(:read)
        id = params.delete("id")
      end
    end

    def build_get_many
      @klass.get '/?' do
        check_permission(:read)
      end
    end
    
    def build_post
      @klass.post '/?' do
        check_permission(:create)
      end
    end
    
    def build_put
      @klass.put '/:id/?' do
        check_permission(:update)
        id = params.delete("id")
      end
    end
    
    def build_delete
      @klass.delete '/:id/?' do
        check_permission(:delete)
        id = params.delete("id")
      end
    end
    
    def build_helpers
      @klass.helpers do
        def check_permission(action)
          # unauthorized! unless ...
        end
      end
    end
    
  end
  
end
