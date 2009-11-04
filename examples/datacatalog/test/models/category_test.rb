require File.expand_path(File.dirname(__FILE__) + '/../helpers/model_test_helper')

class CategoryTest < ModelTestCase
  
  include DataCatalog

  before do
    @required = {
      :name => "Science & Technology"
    }
  end

  context "Category#new" do
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
  
  context "Category with 0 categorizations" do
    before do
      @category = Category.create(@required)
    end
    
    test "#sources should be empty" do
      assert_equal [], @category.sources
    end
  end
  
  context "Category with 3 categorizations" do
    before do
      @category = Category.create(@required)
      @sources = 3.times.map do |i|
        create_source(
          :title => "Source #{i}"
        )
      end
      @categorizations = 3.times.map do |i|
        create_categorization(
          :category_id => @category.id,
          :source_id   => @sources[i].id
        )
      end
    end
  
    test "#sources should have 3 categorizations" do
      categorizations = @category.categorizations
      assert_equal 3, categorizations.length
      3.times do |i|
        assert_include @categorizations[i], categorizations
      end
    end

    test "#sources should have 3 sources" do
      sources = @category.sources
      assert_equal 3, sources.length
      3.times do |i|
        assert_include @sources[i], sources
      end
    end
  end

end
