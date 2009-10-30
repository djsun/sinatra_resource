require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesUsagesGetManySearchResourceTest < ResourceTestCase

  include DataCatalog

  def app; Sources end

  SEARCH_FILTERS = [
    { :filter => "description=academic" },
    { :filter => "description:cad" },
  ]

  before do
    @sources = 3.times.map do |i|
      create_source(:title => "Source #{i}")
    end
    @sources.each do |source|
      4.times do |i|
        source.usages << new_usage(
          :title       => "Usage #{i}",
          :description => (i % 2 == 0) ? "academic" : "press"
        )
      end
      source.save!
    end
    @source = @sources[1]
    @search = SEARCH_FILTERS[0]
  end
  
  after do
    @sources.each { |x| x.destroy }
  end

  context "get /:id/usages" do
    context "anonymous" do
      before do
        get "/#{@source.id}/usages", @search
      end
      
      use "return 401 because the API key is missing"
    end
  
    context "incorrect API key" do
      before do
        get "/#{@source.id}/usages", @search.merge(
          :api_key => BAD_API_KEY)
      end
      
      use "return 401 because the API key is invalid"
    end
  end

  %w(basic curator admin).each do |role|
    context "#{role} : get /:fake_id/usages" do
      before do
        get "/#{FAKE_ID}/usages", @search.merge(
          :api_key => api_key_for(role))
      end
    
      use "return 404 Not Found with empty response body"
    end
  
    SEARCH_FILTERS.each do |search|
      context "#{role} : get /:id/usages" do
        before do
          get "/#{@source.id}/usages", search.merge(
            :api_key => api_key_for(role))
        end
      
        use "return 200 Ok"
      
        test "body should have 2 sources" do
          assert_equal 2, parsed_response_body.length
        end
      
        test "body should have correct source titles" do
          actual = parsed_response_body.map { |e| e["title"] }
          assert_equal ["Usage 0", "Usage 2"], actual.sort
        end
      
        docs_properties %w(title url description id)
      end
    end
  end

end
