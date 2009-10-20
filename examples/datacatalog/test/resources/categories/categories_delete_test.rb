require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class CategoriesDeleteResourceTest < ResourceTestCase

  include DataCatalog

  def app; Categories end

  before do
    @category = create_category
    @category_count = Category.all.length
  end

  after do
    @category.destroy
  end

  shared "no change in category count" do
    test "should not change number of category documents in database" do
      assert_equal @category_count, Category.all.length
    end
  end

  shared "one less category" do
    test "should remove one category document from database" do
      assert_equal @category_count - 1, Category.all.length
    end
  end
  
  context "delete /:id" do
    context "anonymous" do
      before do
        delete "/#{@category.id}"
      end
    
      use "return 401 because the API key is missing"
      use "no change in category count"
    end

    context "incorrect API key" do
      before do
        delete "/#{@category.id}", :api_key => BAD_API_KEY
      end
      
      use "return 401 because the API key is invalid"
      use "no change in category count"
    end
  end
  
  %w(basic).each do |role|
    context "#{role} : delete /:fake_id" do
      before do
        delete "/#{FAKE_ID}", :api_key => api_key_for(role)
      end
      
      use "return 401 Unauthorized"
      use "no change in category count"
    end

    context "#{role} : delete /:id" do
      before do
        delete "/#{@category.id}",
          :api_key => api_key_for(role),
          :key     => "value"
      end
      
      use "return 401 Unauthorized"
      use "no change in category count"
    end

    context "#{role} : delete /:id" do
      before do
        delete "/#{@category.id}", :api_key => api_key_for(role)
      end
      
      use "return 401 Unauthorized"
      use "no change in category count"
    end
  end

  %w(curator admin).each do |role|
    context "#{role} : delete /:fake_id" do
      before do
        delete "/#{FAKE_ID}", :api_key => api_key_for(role)
      end
      
      use "return 404 Not Found"
      use "no change in category count"
    end

    context "#{role} : delete /:id" do
      before do
        delete "/#{@category.id}",
          :api_key => api_key_for(role),
          :key     => "value"
      end
      
      use "return 400 because parameters were not empty"
      use "no change in category count"
    end

    context "#{role} : delete /:id" do
      before do
        delete "/#{@category.id}", :api_key => api_key_for(role)
      end
      
      use "return 204 No Content"
      use "one less category"
    end
  end
  
end
