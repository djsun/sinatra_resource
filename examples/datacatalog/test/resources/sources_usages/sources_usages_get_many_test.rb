require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesUsagesGetManyResourceTest < ResourceTestCase

  include DataCatalog

  def app; Sources end

  before do
    @source = create_source(:title => "Source A")
    3.times do |i|
      @source.usages << new_usage(:title => "Usage #{i}A")
    end
    @source.save
    @usage_titles = ["Usage 0A", "Usage 1A", "Usage 2A"].sort

    @other_source = create_source(:title => "Source B")
    3.times do |i|
      @other_source.usages << new_usage(:title => "Usage #{i}B")
    end
    @other_source.save
  end
  
  after do
    @other_source.destroy
    @source.destroy
  end

  context "get /:id/usages" do
    context "anonymous" do
      before do
        get "/#{@source.id}/usages"
      end
      
      use "return 401 because the API key is missing"
    end
  
    context "incorrect API key" do
      before do
        get "/#{@source.id}/usages", :api_key => BAD_API_KEY
      end
      
      use "return 401 because the API key is invalid"
    end
  end

  %w(basic curator admin).each do |role|
    context "#{role} : get /:fake_id/usages" do
      before do
        get "/#{FAKE_ID}/usages", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
    end
  
    context "#{role} : get /:id/usages" do
      before do
        get "/#{@source.id}/usages", :api_key => api_key_for(role)
      end
      
      use "return 200 Ok"
      
      test "body should have 3 sources" do
        assert_equal 3, parsed_response_body.length
      end
      
      test "body should have correct source titles" do
        actual = parsed_response_body.map { |e| e["title"] }
        assert_equal @usage_titles, actual.sort
      end
      
      docs_properties %w(title url description id)
    end
  end

end
