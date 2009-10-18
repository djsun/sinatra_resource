module SinatraResource

  class Builder
    
    def initialize(options)
      @klass = options[:klass]
      @config = options[:config]
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
        check_params(:read)
      end
    end

    def build_get_many
      @klass.get '/?' do
        check_permission(:read)
        check_params(:read)
      end
    end
    
    def build_post
      @klass.post '/?' do
        check_permission(:create)
        check_params(:create)
      end
    end
    
    def build_put
      @klass.put '/:id/?' do
        check_permission(:update)
        id = params.delete("id")
        check_params(:update)
      end
    end
    
    def build_delete
      @klass.delete '/:id/?' do
        check_permission(:delete)
        id = params.delete("id")
        check_params(:delete)
      end
    end
    
    def build_helpers
      @klass.helpers do
        include Helpers
      end
    end
    
  end
  
end
