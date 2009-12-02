require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class CategoriesGetManyResourceTest < ResourceTestCase

  include DataCatalog

  def app; Categories end

  before do
    unless 0 == (c = Category.count)
      raise "Expected 0 for Category.count, found #{c}"
    end
    @categories = 3.times.map do |i|
      create_category(:name => "Category #{i}")
    end
  end
  
  after do
    @categories.each { |x| x.destroy } if @categories
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
        @members = parsed_response_body['members']
      end
  
      use "return 200 Ok"
      
      test "body should have 3 categories" do
        assert_equal 3, @members.length
      end
      
      test "body should have correct category names" do
        actual = @members.map { |e| e["name"] }
        assert_equal CATEGORIES, actual.sort
      end
      
      test "members should only have correct attributes" do
        correct = %w(name log sources id created_at updated_at)
        @members.each do |member|
          assert_properties(correct, member)
        end
      end
    end
  end

end
