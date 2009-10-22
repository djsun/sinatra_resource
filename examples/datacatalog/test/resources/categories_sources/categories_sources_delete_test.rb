require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class CategoriesSourcesDeleteResourceTest < ResourceTestCase

  include DataCatalog

  def app; Categories end
  
  before do
    @category = create_category
    @source = create_source
    @categorization = create_categorization(
      :source_id   => @source.id,
      :category_id => @category.id
    )
    @other_category = create_category
    @other_source = create_source
    @other_categorization = create_categorization(
      :source_id   => @other_source.id,
      :category_id => @other_category.id
    )
    @source_count = Source.all.length
  end

  after do
    @other_categorization.destroy
    @other_source.destroy
    @other_category.destroy
    @categorization.destroy
    @source.destroy
    @category.destroy
  end

  context "delete /:id/sources/:id" do
    context "anonymous" do
      before do
        delete "/#{@category.id}/sources/#{@source.id}"
      end
    
      use "return 401 because the API key is missing"
    end
  
    context "incorrect API key" do
      before do
        delete "/#{@category.id}/sources/#{@source.id}", :api_key => BAD_API_KEY
      end
      
      use "return 401 because the API key is invalid"
    end
  end

  %w(basic).each do |role|
    context "#{role} : delete /:fake_id/sources/:fake_id" do
      before do
        delete "/#{FAKE_ID}/sources/#{FAKE_ID}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
      use "no change in source count"
    end
    
    context "#{role} : delete /:fake_id/sources/:id" do
      before do
        delete "/#{FAKE_ID}/sources/#{@source.id}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
      use "no change in source count"
    end
    
    context "#{role} : delete /:id/sources/:fake_id" do
      before do
        delete "/#{@category.id}/sources/#{FAKE_ID}", :api_key => api_key_for(role)
      end
    
      use "return 401 because the API key is unauthorized"
      use "no change in source count"
    end
  
    context "#{role} : delete /:id/sources/:not_related_id" do
      before do
        delete "/#{@category.id}/sources/#{@other_source.id}",
          :api_key => api_key_for(role)
      end
      
      use "return 401 because the API key is unauthorized"
      use "no change in source count"
    end
  
    context "#{role} : delete /:id/sources/:id" do
      before do
        delete "/#{@category.id}/sources/#{@source.id}", :api_key => api_key_for(role)
      end
      
      use "return 401 because the API key is unauthorized"
      use "no change in source count"
    end
  end
  
  %w(curator admin).each do |role|
    context "#{role} : delete /:fake_id/sources/:fake_id" do
      before do
        delete "/#{FAKE_ID}/sources/#{FAKE_ID}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
      use "no change in source count"
    end
    
    context "#{role} : delete /:fake_id/sources/:id" do
      before do
        delete "/#{FAKE_ID}/sources/#{@source.id}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
      use "no change in source count"
    end
    
    context "#{role} : delete /:id/sources/:fake_id" do
      before do
        delete "/#{@category.id}/sources/#{FAKE_ID}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
      use "no change in source count"
    end
  
    context "#{role} : delete /:id/sources/:not_related_id" do
      before do
        delete "/#{@category.id}/sources/#{@other_source.id}",
          :api_key => api_key_for(role)
      end
      
      use "return 404 Not Found with empty response body"
      use "no change in source count"
    end
  
    context "#{role} : delete /:id/sources/:id" do
      before do
        delete "/#{@category.id}/sources/#{@source.id}", :api_key => api_key_for(role)
      end
      
      use "return 204 No Content"
      use "one less source"
    end
  end
  
end
