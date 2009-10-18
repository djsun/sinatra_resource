module DataCatalog

  module StatusCodeHelpers

    def internal_server_error!
      error 500, nil.to_json
    end

    def invalid_api_key!
      error 401, { "errors" => ["invalid_api_key"] }.to_json
    end
    
    def invalid_document!
      error 400, { "errors" => @document.errors.errors }.to_json
    end

    def missing_api_key!
      error 401, { "errors" => ["missing_api_key"] }.to_json
    end

    def not_found!
      error 404, nil.to_json
    end

    def unauthorized!
      error 401, { "errors" => ["unauthorized_api_key"] }.to_json
    end
    
  end

  if const_defined?("Base")
    class Base
      helpers StatusCodeHelpers
    end
  end
  
end