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
            # puts "\n== check_permission(#{action.inspect})"
            role = lookup_role
            if role == "anonymous" && minimum_role(action) != "anonymous"
              missing_api_key!
            end
            # puts "   role : #{role.inspect}"
            invalid_api_key! unless role
            unauthorized_api_key! unless authorized?(role, action)
          end
        
          def authorized?(role, action)
            klass = config[:roles]
            klass.satisfies?(role, minimum_role(action))
          end
          
          def minimum_role(action)
            rom = read_or_modify?(action)
            config[:permission][rom]
          end
          
          def read_or_modify?(role)
            case role
            when :read
              :read
            when :create
              :modify
            when :update
              :modify
            when :delete
              :modify
            else
              raise "Unexpected role : #{role.inspect}"
            end
          end
        end
      end
    end
    
  end
  
end
