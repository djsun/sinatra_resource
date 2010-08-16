module DataCatalog

  class Base < Sinatra::Base
    before do
      content_type :json
    end
  end

end
