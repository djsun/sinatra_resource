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
  
end
