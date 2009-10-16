require File.expand_path(File.dirname(__FILE__) + '/../helpers/model_test_helper')

class CategorizationTest < Test::Unit::TestCase
  
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
    
    test "#source is correct" do
      assert_equal @source, @categorization.source
    end

    test "#category is correct" do
      assert_equal @category, @categorization.category
    end
  end

  context "Source" do
    before do
      # [Categorization, Category, Source].each { |m| m.destroy_all }
      @source = create_source
    end
  
    context "with no Categorizations" do
      test "#categorizations should be empty" do
        assert @source.categorizations.empty?
      end
    end

    context "with 3 Categorizations" do
      before do
        @categories = %w(Energy Finance Poverty).map do |name|
          create_category(:name => name)
        end
        @categorizations = @categories.map do |category|
          create_categorization(
            :source_id   => @source.id,
            :category_id => category.id
          )
        end
        @source = Source.find_by_id(@source.id)
      end
      
      # test "Source#categorizations should be correct" do
      #   categorizations = @source.categorizations
      #   @categorizations.each do |categorization|
      #     assert_include categorization, categorizations
      #   end
      # end

      test "Source#categories should be correct" do
        categories = @source.categories
        @categories.each do |category|
          assert_include category, categories
        end
      end

      test "Category#sources should be correct" do
        @categories.each do |category|
          assert_include @source, category.sources
        end
      end
    end
  end

end
