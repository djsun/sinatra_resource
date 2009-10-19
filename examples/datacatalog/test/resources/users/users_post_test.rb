require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class UsersPostResourceTest < ResourceTestCase

  def app; DataCatalog::Users end
  
  before do
    @valid_params = {
      :name => "New User",
      :role => "basic"
    }
  end
  
  context "post /" do
    context "anonymous" do
      before do
        post "/", @valid_params
      end
    
      use "return 401 because the API key is missing"
    end

    context "incorrect API key" do
      before do
        post "/", @valid_params.merge(:api_key => BAD_API_KEY)
      end
  
      use "return 401 because the API key is invalid"
    end
  end

  %w(basic curator).each do |role|
    [:name, :role].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end
  
        use "return 401 Unauthorized"
      end
    end
  
    [:role, :_api_key, :id, :created_at, :updated_at].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 401 Unauthorized"
      end
    end
  
    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role)
      end
      
      use "return 401 Unauthorized"
    end
  end

  %w(admin).each do |role|
    [:name, :role].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).merge(
            :role     => "basic",
            :_api_key => "222200004444"
          ).delete_if { |k, v| k == missing }
        end
        
        use "return 400 Bad Request"
        missing_param missing
      end
    end
  
    [:id, :created_at, :updated_at].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).merge(
            :role     => "basic",
            :_api_key => "222200004444",
            invalid   => 9
          )
        end
  
        use "return 400 Bad Request"
        invalid_param invalid
      end
    end
  
    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role).merge(
          :role     => "basic",
          :_api_key => "222200004444"
        )
      end
  
      use "return 200 Ok"
      doc_properties %w(name email role _api_key id created_at updated_at)
    end
  end

end
