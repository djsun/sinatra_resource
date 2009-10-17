module DataCatalog
  
  class Base < Sinatra::Base
    before do
      content_type :json
    end
    
    helpers do
      def lookup_role
        api_key = params.delete("api_key")
        return "anonymous" unless api_key
        @current_user = User.find_by_api_key(api_key)
        @current_user.role
      end
    end
  end
  
end
