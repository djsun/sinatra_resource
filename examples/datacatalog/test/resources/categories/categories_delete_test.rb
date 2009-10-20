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
  
  context "delete /" do
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
  
end
