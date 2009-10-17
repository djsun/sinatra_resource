require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesGetOneResourceTest < ResourceTestCase

  def app; DataCatalog::Sources end

  before do
    @source = create_source
  end

  context "get /:id" do
    context "anonymous" do
      before do
        get "/#{@source.id}"
      end
      
      use "return 401 because the API key is missing"
    end

    context "incorrect API key" do
      before do
        get "/#{@source.id}", :api_key => BAD_API_KEY
      end
    
      use "return 401 because the API key is invalid"
    end
  end

end
