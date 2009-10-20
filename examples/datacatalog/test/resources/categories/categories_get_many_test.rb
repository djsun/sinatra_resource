require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class CategoriesGetManyResourceTest < ResourceTestCase

  def app; DataCatalog::Categories end

  before do
    @categories = 3.times.map do |i|
      create_category(:name => "Category #{i}")
    end
  end
  
  after do
    @categories.each { |x| x.destroy }
  end
  
  CATEGORIES = ["Category 0", "Category 1", "Category 2"].sort

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
      
      test "body should have 3 categories" do
        assert_equal 3, parsed_response_body.length
      end
      
      test "body should have correct category names" do
        actual = parsed_response_body.map { |e| e["name"] }
        assert_equal CATEGORIES, actual.sort
      end
      
      docs_properties %w(name sources id created_at updated_at)
    end
  end

end
