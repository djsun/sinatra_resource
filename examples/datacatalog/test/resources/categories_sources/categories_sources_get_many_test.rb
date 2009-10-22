require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class CategoriesSourcesGetManyResourceTest < ResourceTestCase

  include DataCatalog

  def app; Categories end

  before do
    @category = create_category
    @sources = 3.times.map do |i|
      create_source(:title => "Source #{i}")
    end
    @categorizations = 3.times.map do |i|
      create_categorization(
        :source_id   => @sources[i].id,
        :category_id => @category.id
      )
    end
  end
  
  after do
    @categorizations.each { |x| x.destroy }
    @sources.each { |x| x.destroy }
    @category.destroy
  end

  SOURCES = ["Source 0", "Source 1", "Source 2"].sort

  context "get /:id/sources/" do
    context "anonymous" do
      before do
        get "/#{@category.id}/sources/"
      end
    
      use "return 401 because the API key is missing"
    end
  
    context "incorrect API key" do
      before do
        get "/#{@category.id}/sources/", :api_key => BAD_API_KEY
      end
      
      use "return 401 because the API key is invalid"
    end
  end

  %w(basic curator admin).each do |role|
    context "#{role} : get /:id/sources" do
      before do
        get "/#{@category.id}/sources/", :api_key => api_key_for(role)
      end

      use "return 200 Ok"

      test "body should have 3 sources" do
        assert_equal 3, parsed_response_body.length
      end

      test "body should have correct source titles" do
        actual = parsed_response_body.map { |e| e["title"] }
        assert_equal SOURCES, actual.sort
      end

      docs_properties %w(title url raw id created_at updated_at)
    end
  end

end
