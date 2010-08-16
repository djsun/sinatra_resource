require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesGetOneResourceTest < ResourceTestCase

  include DataCatalog

  def app; Sources end

  before do
    @source = create_source
  end

  after do
    @source.destroy
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

  %w(basic curator admin).each do |role|
    context "#{role} : get /:fake_id" do
      before do
        get "/#{FAKE_ID}", :api_key => api_key_for(role)
      end

      use "return 404 Not Found with empty response body"
    end

    context "#{role} : get /:id" do
      before do
        @category = create_category
        @categorization = create_categorization(
          :source_id   => @source.id,
          :category_id => @category.id
        )
        get "/#{@source.id}", :api_key => api_key_for(role)
      end

      after do
        @category.destroy
        @categorization.destroy
      end

      use "return 200 Ok"
      doc_properties %w(title url categories id created_at updated_at)

      test "body should have correct categories" do
        expected = [
          {
            "id"   => @category.id.to_s,
            "href" => "/categories/#{@category.id}",
            "name" => @category.name,
          }
        ]
        assert_equal expected, parsed_response_body["categories"]
      end

      test "correct timestamp format" do
        parsed = parsed_response_body
        assert_equal Time.local(2010, 7, 4, 15, 0, 0), parsed['created_at']
        assert_equal Time.local(2010, 7, 4, 15, 0, 0), parsed['updated_at']
      end
    end

    context "#{role} : get /:id?show=all" do
      before do
        get "/#{@source.id}?show=all", :api_key => api_key_for(role)
      end

      use "return 200 Ok"
      doc_properties %w(title url raw categories id created_at updated_at)
    end
  end

end
