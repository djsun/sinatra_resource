require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class UsersGetManyResourceTest < ResourceTestCase

  def app; DataCatalog::Users end

  before do
    @users = 3.times.map do |i|
      create_user(:name => "User #{i}")
    end
  end
  
  after do
    @users.each { |x| x.destroy }
  end

  context "get /" do
    context "anonymous" do
      before do
        get "/"
      end
    
      use "return 401 because the API key is missing"
    end
  
    context "incorrect API key" do
      before do
        get "/", :api_key => BAD_API_KEY
      end
  
      use "return 401 because the API key is invalid"
    end
  end
  
  %w(basic curator admin).each do |role|
    context "#{role} : get /" do
      before do
        get "/", :api_key => api_key_for(role)
      end
  
      use "return 200 Ok"
      
      test "body should have 6 users" do
        assert_equal 6, parsed_response_body.length
      end
      
      test "body should have correct user names" do
        actual = parsed_response_body.map { |e| e["name"] }
        expected = ["User 0", "User 1", "User 2",
          "admin User", "basic User", "curator User"]
        assert_equal expected, actual.sort
      end
      
      docs_properties %w(name email role _api_key id created_at updated_at)
    end
  end

end
