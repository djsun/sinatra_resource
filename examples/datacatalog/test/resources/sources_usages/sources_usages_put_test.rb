require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesUsagesPutResourceTest < ResourceTestCase

  include DataCatalog

  def app; Sources end
  
  before do
    @source = create_source
    @source.usages << new_usage
    @source.save
    @usage_copy = @source.usages[0]
    @usage_id = @usage_copy.id

    @other_source = create_source
    @other_source.usages << new_usage
    @other_source.save
    @other_usage_id = @other_source.usages[0].id

    @usage_count = @source.usages.length
    @valid_params = {
      :title => "Sample Usage",
      :url   => "http://inter.net/article/100",
    }
  end

  after do
    @other_source.destroy
    @source.destroy
  end

  context "put /:id/usages/:id" do
    context "anonymous" do
      before do
        put "/#{@source.id}/usages/#{@usage_id}"
      end
    
      use "return 401 because the API key is missing"
      use "usage unchanged"
    end
  
    context "incorrect API key" do
      before do
        put "/#{@source.id}/usages/#{@usage_id}", :api_key => BAD_API_KEY
      end
      
      use "return 401 because the API key is invalid"
      use "usage unchanged"
    end
  end
  
  %w(basic).each do |role|
    context "#{role} : put /:fake_id/usages/:fake_id" do
      before do
        put "/#{FAKE_ID}/usages/#{FAKE_ID}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
      use "usage unchanged"
    end
    
    context "#{role} : put /:fake_id/usages/:id" do
      before do
        put "/#{FAKE_ID}/usages/#{@usage_id}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
      use "usage unchanged"
    end
    
    context "#{role} : put /:id/usages/:fake_id" do
      before do
        put "/#{@source.id}/usages/#{FAKE_ID}", :api_key => api_key_for(role)
      end
    
      use "return 401 because the API key is unauthorized"
      use "usage unchanged"
    end
  
    context "#{role} : put /:id/usages/:not_related_id" do
      before do
        put "/#{@source.id}/usages/#{@other_usage_id}",
          :api_key => api_key_for(role)
      end
      
      use "return 401 because the API key is unauthorized"
      use "usage unchanged"
    end
  
    context "#{role} : put /:id/usages/:id" do
      before do
        put "/#{@source.id}/usages/#{@usage_id}", :api_key => api_key_for(role)
      end
      
      use "return 401 because the API key is unauthorized"
      use "usage unchanged"
    end
  end
  
  %w(curator admin).each do |role|
    context "#{role} : put /:fake_id/usages/:fake_id" do
      before do
        put "/#{FAKE_ID}/usages/#{FAKE_ID}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
      use "usage unchanged"
    end
    
    context "#{role} : put /:fake_id/usages/:id" do
      before do
        put "/#{FAKE_ID}/usages/#{@usage_id}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
      use "usage unchanged"
    end
    
    context "#{role} : put /:id/usages/:fake_id" do
      before do
        put "/#{@source.id}/usages/#{FAKE_ID}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
      use "usage unchanged"
    end
  
    context "#{role} : put /:id/usages/:not_related_id" do
      before do
        put "/#{@source.id}/usages/#{@other_usage_id}",
          :api_key => api_key_for(role)
      end
      
      use "return 404 Not Found with empty response body"
      use "usage unchanged"
    end
  
    context "#{role} : put /:id/usages/:id with no params" do
      before do
        put "/#{@source.id}/usages/#{@usage_id}", 
          :api_key => api_key_for(role)
      end
  
      use "return 400 because no params were given"
      use "usage unchanged"
    end
  
    # TODO: As of 2009-10-29, MongoMapper does not support validations on
    # EmbeddedDocuments.
    #
    # [:title, :url].each do |missing|
    #   context "#{role} : put /:id/usages/:id without #{missing}" do
    #     before do
    #       put "/#{@source.id}/usages/#{@usage_id}",
    #         valid_params_for(role).delete_if { |k, v| k == missing }
    #     end
    #   
    #     use "return 200 Ok"
    #     doc_properties %w(title url description id)
    # 
    #     test "should change correct fields in database" do
    #       usage = @source.usages[0]
    #       @valid_params.each_pair do |key, value|
    #         assert_equal(value, usage[key]) if key != missing
    #       end
    #       assert_equal @usage_copy[missing], usage[missing]
    #     end
    #   end
    # end
    
    # TODO: As of 2009-10-29, MongoMapper does not support validations on
    # EmbeddedDocuments.
    #
    # [:title, :url].each do |erase|
    #   context "#{role} : put /:id/usages/:id but blanking out #{erase}" do
    #     before do
    #       put "/#{@source.id}/usages/#{@usage_id}",
    #         valid_params_for(role).merge(erase => "")
    #     end
    #   
    #     use "return 400 Bad Request"
    #     use "usage unchanged"
    #     missing_param erase
    #   end
    # end
  
    [:junk].each do |invalid|
      context "#{role} : put /:id/usages/:id with #{invalid}" do
        before do
          put "/#{@source.id}/usages/#{@usage_id}",
            valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 400 Bad Request"
        use "usage unchanged"
        invalid_param invalid
      end
    end

    context "#{role} : put /:id/usages/:id with valid params" do
      before do
        put "/#{@source.id}/usages/#{@usage_id}", valid_params_for(role)
      end
      
      use "return 200 Ok"
      doc_properties %w(title url description id)
          
      test "should change correct fields in database" do
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
