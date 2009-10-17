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
      @klass.instance_eval do
        helpers do
          def check_permission(action)
            role = lookup_role
            unauthorized_api_key! unless authorized?(role, action)
          end
        
          def authorized?(role, action)
            puts "\n== authorized?"
            # puts "-  config : #{config.inspect}"
            # puts @resource_config[:permissions].inspect
            puts config[:permission].inspect
            puts config[:property].inspect
          end
        end
      end
    end
    
  end
  
end
