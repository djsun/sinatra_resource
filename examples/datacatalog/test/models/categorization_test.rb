require File.expand_path(File.dirname(__FILE__) + '/../helpers/model_test_helper')

class CategorizationTest < ModelTestCase
  
  include DataCatalog
  
  context "Categorization" do
    before do
      @source = create_source
      @category = create_category
      @categorization = create_categorization(
        :source_id   => @source.id,
        :category_id => @category.id
      )
    end
    
    after do
      @source.destroy
      @category.destroy
      @categorization.destroy
    end
    
    test "Categorization#source is correct" do
      assert_equal @source, @categorization.source
    end

    test "Categorization#category is correct" do
      assert_equal @category, @categorization.category
    end
    
    test "Source#categorization is correct" do
      assert_equal [@categorization], @source.categorizations
    end

    test "Category#categorization is correct" do
      assert_equal [@categorization], @category.categorizations
    end
  end

end
