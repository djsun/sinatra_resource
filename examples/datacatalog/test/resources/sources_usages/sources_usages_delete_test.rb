require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesUsagesDeleteResourceTest < ResourceTestCase

  include DataCatalog

  def app; Sources end

  before do
    @source = create_source
    @source.usages << new_usage
    @source.save
    @usage_id = @source.usages[0].id
    @usage_count = @source.usages.length

    @other_source = create_source
    @other_source.usages << new_usage
    @other_source.save
    @other_usage_id = @other_source.usages[0].id
  end

  context "delete /:id/usages/:id" do
    context "anonymous" do
      before do
        delete "/#{@source.id}/usages/#{@usage_id}"
      end

      use "return 401 because the API key is missing"
    end

    context "incorrect API key" do
      before do
        delete "/#{@source.id}/usages/#{@usage_id}",
          :api_key => BAD_API_KEY
      end

      use "return 401 because the API key is invalid"
    end
  end

  %w(basic).each do |role|
    context "#{role} : delete /:fake_id/usages/:fake_id" do
      before do
        delete "/#{FAKE_ID}/usages/#{FAKE_ID}",
          :api_key => api_key_for(role)
      end

      use "return 404 Not Found with empty response body"
      use "no change in usage count"
    end

    context "#{role} : delete /:fake_id/usages/:id" do
      before do
        delete "/#{FAKE_ID}/usages/#{@usage_id}",
          :api_key => api_key_for(role)
      end

      use "return 404 Not Found with empty response body"
      use "no change in usage count"
    end

    context "#{role} : delete /:id/usages/:fake_id" do
      before do
        delete "/#{@source.id}/usages/#{FAKE_ID}", :api_key => api_key_for(role)
      end

      use "return 401 because the API key is unauthorized"
      use "no change in usage count"
    end

    context "#{role} : delete /:id/usages/:not_related_id" do
      before do
        delete "/#{@source.id}/usages/#{@other_usage_id}",
          :api_key => api_key_for(role)
      end

      use "return 401 because the API key is unauthorized"
      use "no change in usage count"
    end

    context "#{role} : delete /:id/usages/:id" do
      before do
        delete "/#{@source.id}/usages/#{@usage_id}",
          :api_key => api_key_for(role)
      end

      use "return 401 because the API key is unauthorized"
      use "no change in usage count"
    end
  end

  %w(curator).each do |role|
  # %w(curator admin).each do |role|
    context "#{role} : delete /:fake_id/usages/:fake_id" do
      before do
        delete "/#{FAKE_ID}/usages/#{FAKE_ID}",
          :api_key => api_key_for(role)
      end

      use "return 404 Not Found with empty response body"
      use "no change in usage count"
    end

    context "#{role} : delete /:fake_id/usages/:id" do
      before do
        delete "/#{FAKE_ID}/usages/#{@usage_id}",
          :api_key => api_key_for(role)
      end

      use "return 404 Not Found with empty response body"
      use "no change in usage count"
    end

    context "#{role} : delete /:id/usages/:fake_id" do
      before do
        delete "/#{@source.id}/usages/#{FAKE_ID}",
          :api_key => api_key_for(role)
      end

      use "return 404 Not Found with empty response body"
      use "no change in usage count"
    end

    context "#{role} : delete /:id/usages/:not_related_id" do
      before do
        delete "/#{@source.id}/usages/#{@other_usage_id}",
          :api_key => api_key_for(role)
      end

      use "return 404 Not Found with empty response body"
      use "no change in usage count"
    end

    context "#{role} : delete /:id/usages/:id" do
      before do
        delete "/#{@source.id}/usages/#{@usage_id}",
          :api_key => api_key_for(role)
      end

      use "return 204 No Content"
      use "one less usage"
    end
  end

end
