require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesUsagesGetOneResourceTest < ResourceTestCase

  include DataCatalog

  def app; Sources end
  
  before do
    @source = create_source
    @source.usages << new_usage
    @source.save
    @usage_id = @source.usages[0].id

    @other_source = create_source
    @other_source.usages << new_usage
    @other_source.save
    @other_usage_id = @other_source.usages[0].id
  end

  after do
    @other_source.destroy
    @source.destroy
  end

  context "get /:id/usages/:id" do
    context "anonymous" do
      before do
        get "/#{@source.id}/usages/#{@usage_id}"
      end
    
      use "return 401 because the API key is missing"
    end
  
    context "incorrect API key" do
      before do
        get "/#{@source.id}/usages/#{@usage_id}", :api_key => BAD_API_KEY
      end
      
      use "return 401 because the API key is invalid"
    end
  end
  
  %w(basic).each do |role|
  # %w(basic curator admin).each do |role|
    context "#{role} : get /:fake_id/usages/:fake_id" do
      before do
        get "/#{FAKE_ID}/usages/#{FAKE_ID}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
    end
    
    context "#{role} : get /:fake_id/usages/:id" do
      before do
        get "/#{FAKE_ID}/usages/#{@usage_id}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
    end
    
    context "#{role} : get /:id/usages/:fake_id" do
      before do
        get "/#{@source.id}/usages/#{FAKE_ID}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
    end
      
    context "#{role} : get /:id/usages/:not_related_id" do
      before do
        get "/#{@source.id}/usages/#{@other_usage_id}",
          :api_key => api_key_for(role)
      end
      
      use "return 404 Not Found with empty response body"
    end
      
    context "#{role} : get /:id/usages/:id" do
      before do
        get "/#{@source.id}/usages/#{@usage_id}", :api_key => api_key_for(role)
      end
      
      use "return 200 Ok"
      doc_properties %w(title url description id)
    end
  end
  
end
