require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class CategoriesGetOneResourceTest < ResourceTestCase

  include DataCatalog

  def app; Categories end
  
  before do
    @category = create_category
  end
  
  after do
    @category.destroy
  end

  context "get /:id" do
    context "anonymous" do
      before do
        get "/#{@category.id}"
      end
    
      use "return 401 because the API key is missing"
    end

    context "incorrect API key" do
      before do
        get "/#{@category.id}", :api_key => BAD_API_KEY
      end
  
      use "return 401 because the API key is invalid"
    end
  end

  %w(basic curator admin).each do |role|
    context "#{role} : get /:fake_id" do
      before do
        get "/#{FAKE_ID}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
    end

    context "#{role} : get /:id" do
      before do
        @source = create_source
        @categorization = create_categorization(
          :source_id   => @source.id,
          :category_id => @category.id
        )
        get "/#{@category.id}", :api_key => api_key_for(role)
      end
      
      after do
        @source.destroy
        @categorization.destroy
      end

      use "return 200 Ok"
      doc_properties %w(name log id created_at updated_at sources)
      
      test "body should have correct sources" do
        expected = [
          {
            "id"    => @source.id,
            "href"  => "/sources/#{@source.id}",
            "title" => @source.title,
            "url"   => @source.url,
          }
        ]
        assert_equal expected, parsed_response_body["sources"]
      end
    end
  end

end
