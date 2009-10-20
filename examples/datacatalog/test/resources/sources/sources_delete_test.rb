require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesDeleteResourceTest < ResourceTestCase

  include DataCatalog

  def app; Sources end

  before do
    @source = create_source
    @source_count = Source.all.length
  end

  after do
    @source.destroy
  end

  shared "no change in source count" do
    test "should not change number of source documents in database" do
      assert_equal @source_count, Source.all.length
    end
  end

  shared "one less source" do
    test "should remove one source document from database" do
      assert_equal @source_count - 1, Source.all.length
    end
  end
  
  context "delete /:id" do
    context "anonymous" do
      before do
        delete "/#{@source.id}"
      end
    
      use "return 401 because the API key is missing"
      use "no change in source count"
    end

    context "incorrect API key" do
      before do
        delete "/#{@source.id}", :api_key => BAD_API_KEY
      end
      
      use "return 401 because the API key is invalid"
      use "no change in source count"
    end
  end
  
  %w(basic).each do |role|
    context "#{role} : delete /:fake_id" do
      before do
        delete "/#{FAKE_ID}", :api_key => api_key_for(role)
      end
      
      use "return 401 Unauthorized"
      use "no change in source count"
    end

    context "#{role} : delete /:id" do
      before do
        delete "/#{@source.id}",
          :api_key => api_key_for(role),
          :key     => "value"
      end
      
      use "return 401 Unauthorized"
      use "no change in source count"
    end

    context "#{role} : delete /:id" do
      before do
        delete "/#{@source.id}", :api_key => api_key_for(role)
      end
      
      use "return 401 Unauthorized"
      use "no change in source count"
    end
  end

  %w(curator admin).each do |role|
    context "#{role} : delete /:fake_id" do
      before do
        delete "/#{FAKE_ID}", :api_key => api_key_for(role)
      end
      
      use "return 404 Not Found"
      use "no change in source count"
    end

    context "#{role} : delete /:id" do
      before do
        delete "/#{@source.id}",
          :api_key => api_key_for(role),
          :key     => "value"
      end
      
      use "return 400 because parameters were not empty"
      use "no change in source count"
    end

    context "#{role} : delete /:id" do
      before do
        delete "/#{@source.id}", :api_key => api_key_for(role)
      end
      
      use "return 204 No Content"
      use "one less source"
    end
  end
  
end
