require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class CategoriesSourceGetOneResourceTest < ResourceTestCase

  def app; DataCatalog::Categories end
  
  before do
    @category = create_category
    @source = create_source
    @categorization = create_categorization(
      :source_id   => @source.id,
      :category_id => @category.id
    )
  end
  
  after do
    @categorization.destroy
    @source.destroy
    @category.destroy
  end

  context "get /:id" do
    context "anonymous" do
      before do
        get "/#{@category.id}/sources/#{@source.id}"
      end
    
      use "return 401 because the API key is missing"
    end
  
    context "incorrect API key" do
      before do
        get "/#{@category.id}/sources/#{@source.id}", :api_key => BAD_API_KEY
      end
      
      use "return 401 because the API key is invalid"
    end
  end
  
  %w(basic curator admin).each do |role|
    context "#{role} : get /:fake_id" do
      before do
        get "/#{@category.id}/sources/#{FAKE_ID}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found"
      use "return an empty response body"
    end

    context "#{role} : get /:id" do
      before do
        get "/#{@category.id}/sources/#{@source.id}", :api_key => api_key_for(role)
      end
      
      use "return 200 Ok"
      doc_properties %w(title url raw id created_at updated_at)
    end
  end

end
