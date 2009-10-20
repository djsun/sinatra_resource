require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class UsersPostResourceTest < ResourceTestCase

  include DataCatalog

  def app; Users end
  
  before do
    @user_count = User.all.length
    @valid_params = {
      :name => "New User",
      :role => "basic"
    }
    @extra_admin_params = {
      :role     => "basic",
      :_api_key => "222200004444"
    }
  end

  shared "no new users" do
    test "should not change number of user documents in database" do
      assert_equal @user_count, User.all.length
    end
  end

  shared "one new user" do
    test "should add one user document to database" do
      assert_equal @user_count + 1, User.all.length
    end
  end
  
  context "post /" do
    context "anonymous" do
      before do
        post "/", @valid_params
      end
    
      use "return 401 because the API key is missing"
      use "no new users"
    end

    context "incorrect API key" do
      before do
        post "/", @valid_params.merge(:api_key => BAD_API_KEY)
      end
  
      use "return 401 because the API key is invalid"
      use "no new users"
    end
  end

  %w(basic curator).each do |role|
    [:name, :role].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end
  
        use "return 401 Unauthorized"
        use "no new users"
      end
    end
  
    [:role, :_api_key, :id, :created_at, :updated_at].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 401 Unauthorized"
        use "no new users"
      end
    end
  
    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role)
      end
      
      use "return 401 Unauthorized"
      use "no new users"
    end
  end

  %w(admin).each do |role|
    [:name, :role].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).
            merge(@extra_admin_params).delete_if { |k, v| k == missing }
        end
        
        use "return 400 Bad Request"
        use "no new users"
        missing_param missing
      end
    end
  
    [:id, :created_at, :updated_at].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).
            merge(@extra_admin_params).merge(invalid => 9)
        end
  
        use "return 400 Bad Request"
        use "no new users"
        invalid_param invalid
      end
    end
  
    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role).merge(@extra_admin_params)
      end
  
      use "return 201 Created"
      use "one new user"
      doc_properties %w(name email role _api_key id created_at updated_at)

      test "should set all fields in database" do
        user = User.find_by_id(parsed_response_body["id"])
        raise "Cannot find user" unless user
        @valid_params.merge(@extra_admin_params).each_pair do |key, value|
          assert_equal value, user[key]
        end
      end
    end
  end

end
