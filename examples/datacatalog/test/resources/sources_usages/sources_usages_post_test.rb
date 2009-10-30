require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesUsagesPostResourceTest < ResourceTestCase

  include DataCatalog

  def app; Sources end

  before do
    @source = create_source
    @usage_count = @source.usages.length
    @valid_params = {
      :title => "Sample Usage",
      :url   => "http://inter.net/article/100",
    }
  end

  after do
    @source.destroy
  end
  
  context "post /:id/usages" do
    context "anonymous" do
      before do
        post "/#{@source.id}/usages"
      end
    
      use "return 401 because the API key is missing"
      use "no change in usage count"
    end
  
    context "incorrect API key" do
      before do
        post "/#{@source.id}/usages", :api_key => BAD_API_KEY
      end
      
      use "return 401 because the API key is invalid"
      use "no change in usage count"
    end
  end
  
  %w(basic).each do |role|
    context "#{role} : post /:fake_id/usages" do
      before do
        post "/#{FAKE_ID}/usages", :api_key => api_key_for(role)
      end
  
      use "return 404 Not Found with empty response body"
      use "no change in usage count"
    end
  
    context "#{role} : post /:id/usages" do
      before do
        post "/#{@source.id}/usages", :api_key => api_key_for(role)
      end
    
      use "return 401 because the API key is unauthorized"
      use "no change in usage count"
    end
  end
  
  %w(curator admin).each do |role|
    context "#{role} : post /:fake_id/usages" do
      before do
        post "/#{FAKE_ID}/usages", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
      use "no change in usage count"
    end

    # TODO: As of 2009-10-29, MongoMapper does not support validations on
    # EmbeddedDocuments.
    #
    # [:title, :url].each do |missing|
    #   context "#{role} : post /:id/usages but missing #{missing}" do
    #     before do
    #       post "/#{@source.id}/usages",
    #         valid_params_for(role).delete_if { |k, v| k == missing }
    #     end
    #     
    #     use "return 400 Bad Request"
    #     use "no change in usage count"
    #     missing_param missing
    #   end
    # end
    
    [:junk].each do |invalid|
      context "#{role} : post /:id/usages/ but with #{invalid}" do
        before do
          post "/#{@source.id}/usages", valid_params_for(role).
            merge(invalid => 9)
        end
      
        use "return 400 Bad Request"
        use "no change in usage count"
        invalid_param invalid
      end
    end

    context "#{role} : post /:id/usages with valid params" do
      before do
        post "/#{@source.id}/usages", valid_params_for(role)
      end
      
      use "return 201 Created"
      nested_location_header "sources", :source, "usages"
      use "one new usage"
      doc_properties %w(title url description id)
      
      test "new usage created correctly" do
        source = Source.find_by_id(@source.id)
        # TODO: use reload instead
        usages = source.usages
        assert_equal 1, usages.length
        usage = usages[0]
        @valid_params.each_pair do |key, value|
          assert_equal value, usage[key]
        end
      end
    end
  end
  
end
