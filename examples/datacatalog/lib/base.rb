module DataCatalog
  
  class Base < Sinatra::Base
    before do
      content_type :json
    end
    
    helpers do
      def lookup_role(document=nil)
        api_key = params.delete("api_key")
        return :anonymous unless api_key
        role_for(api_key, document)
      end
      
      def role_for(api_key, document=nil)
        user = user_for(api_key)
        return nil unless user
        return :owner if document && owner?(user, document)
        user.role.intern
      end
      
      def user_for(api_key)
        user = User.first(:conditions => { :_api_key => api_key })
        return nil unless user
        raise "API key found, but user has no role" unless user.role
        user
      end
      
      # Is +user+ the owner of +document+?
      #
      # First, checks to see if +user+ and +document+ are the same. After
      # that, try to follow the +document.user+ relationship, if present, to
      # see if that points to +user+.
      #
      # @param [DataCatalog::User] user
      #
      # @param [MongoMapper::Document] user
      #
      # @return [Boolean]
      def owner?(user, document)
        return true if user == document
        return false unless document.respond_to?(:user)
        document.user == user
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
