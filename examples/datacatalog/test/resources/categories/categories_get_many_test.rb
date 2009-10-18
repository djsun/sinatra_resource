require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class UsersGetOneResourceTest < ResourceTestCase

  def app; DataCatalog::Users end

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
    before do
      @user = create_user(:role => role)
    end
    
    after do
      @user.destroy
    end
  
    context "#{role} : get /" do
      before do
        get "/", :api_key => @user.api_key
      end
  
      use "return 200 Ok"
      docs_properties %w(name email role api_key id created_at updated_at)
    end
  end

end
