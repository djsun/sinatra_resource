require File.expand_path(File.dirname(__FILE__) + '/../helpers/model_test_helper')

class CategoryTest < ModelTestCase
  
  include DataCatalog

  context "Category" do
    before do
      @required = {
        :name => "Science & Technology"
      }
    end
  
    context "correct params" do
      before do
        @category = Category.new(@required)
      end
      
      test "should be valid" do
        assert_equal true, @category.valid?
      end
    end
    
    [:name].each do |missing|
      context "missing #{missing}" do
        before do
          @category = Category.new(@required.delete_if { |k, v| k == missing })
        end
        
        missing_key(:category, missing)
      end
    end
  end
  
end
