require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class UsersGetOneResourceTest < ResourceTestCase

  def app; DataCatalog::Users end

  before :all do    # MongoMapper.database.drop_collection('users')
    @users = 3.times.map do |i|
      create_user(:name => "User #{i}")
    end
    @roles = {}
    %w(basic curator admin).map do |role|
      @roles[role] = create_user(
        :name => "#{role} User",
        :role => role
      )
    end
  end
  
  after :all do
    @users.each { |x| x.destroy }
    @roles.each_pair { |role, user| user.destroy }
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
        get "/", :api_key => @roles[role].api_key
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
      
      docs_properties %w(name email role api_key id created_at updated_at)
    end
  end

end
