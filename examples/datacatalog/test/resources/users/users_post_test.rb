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

  context "post /" do
    context "anonymous" do
      before do
        post "/", @valid_params
      end
    
      use "return 401 because the API key is missing"
      use "no change in user count"
    end

    context "incorrect API key" do
      before do
        post "/", @valid_params.merge(:api_key => BAD_API_KEY)
      end
  
      use "return 401 because the API key is invalid"
      use "no change in user count"
    end
  end

  %w(basic curator).each do |role|
    [:name, :role].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end
  
        use "return 401 because the API key is unauthorized"
        use "no change in user count"
      end
    end
  
    [:role, :_api_key, :id, :created_at, :updated_at, :junk].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 401 because the API key is unauthorized"
        use "no change in user count"
      end
    end
  
    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role)
      end
      
      use "return 401 because the API key is unauthorized"
      use "no change in user count"
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
        use "no change in user count"
        missing_param missing
      end
    end
  
    [:id, :created_at, :updated_at, :junk].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).
            merge(@extra_admin_params).merge(invalid => 9)
        end
  
        use "return 400 Bad Request"
        use "no change in user count"
        invalid_param invalid
      end
    end
  
    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role).merge(@extra_admin_params)
      end

      after do
        User.find_by_id(parsed_response_body["id"]).destroy
      end
  
      use "return 201 Created"
      location_header "users"
      use "one new user"
      doc_properties %w(name email role _api_key token
        id created_at updated_at)

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
