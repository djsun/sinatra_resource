require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesGetManyResourceTest < ResourceTestCase

  def app; DataCatalog::Sources end

  before do
    @sources = 3.times.map do |i|
      create_source(:title => "Source #{i}")
    end
  end
  
  after do
    @sources.each { |x| x.destroy }
  end

  context "get /" do
    context "anonymous" do
      before do
        get "/"
      end
    
      use "return 401 because the API key is missing"
    end
  
    context "incorrect API key" do
      before do
        get "/", :api_key => BAD_API_KEY
      end
  
      use "return 401 because the API key is invalid"
    end
  end

  %w(basic curator admin).each do |role|
    context "#{role} : get /" do
      before do
        get "/", :api_key => api_key_for(role)
      end
  
      use "return 200 Ok"
      
      test "body should have 3 sources" do
        assert_equal 3, parsed_response_body.length
      end
      
      test "body should have correct source titles" do
        actual = parsed_response_body.map { |e| e["title"] }
        expected = ["Source 0", "Source 1", "Source 2"]
        assert_equal expected, actual.sort
      end
      
      docs_properties %w(title url raw id created_at updated_at)
    end
  end

end
