module DataCatalog
  
  class Base < Sinatra::Base
    before do
      content_type :json
    end
    
    helpers do
      def lookup_role
        api_key = params.delete("api_key")
        return :anonymous unless api_key
        user = User.find_by_api_key(api_key)
        return nil unless user
        role = user.role
        return nil unless role
        role.intern
      end

      def before_authorization(action, role)
        unless role
          error 401, display({ "errors" => ["invalid_api_key"] })
        end
        if role == :anonymous && minimum_role(action) != :anonymous
          error 401, display({ "errors" => ["missing_api_key"] })
        end
      end
    end
  end
  
end
