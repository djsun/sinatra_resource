require File.expand_path(File.dirname(__FILE__) + '/../helpers/model_test_helper')

class CategoryTest < Test::Unit::TestCase
  
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

    context "missing name" do
      before do
        @category = Category.new(@required.merge(:name => ""))
      end
    
      test "should be invalid" do
        assert_equal false, @category.valid?
      end

      test "should have errors" do
        @category.valid?
        expected = "can't be empty"
        assert_include expected, @category.errors.errors[:name]
      end
    end
  end
  
end
