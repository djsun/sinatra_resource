require File.dirname(__FILE__) + '/resource'

module DataCatalog
  
  class Base < Sinatra::Base
    before do
      content_type :json
    end

    include Resource
  end
  
end
