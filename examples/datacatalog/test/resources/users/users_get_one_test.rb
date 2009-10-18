require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class UsersGetOneResourceTest < ResourceTestCase

  def app; DataCatalog::Users end
  
  before do
    @user = create_user
  end

  context "get /:id" do
    context "anonymous" do
      before do
        get "/#{@user.id}"
      end
    
      use "return 401 because the API key is missing"
    end

    context "incorrect API key" do
      before do
        get "/#{@user.id}", :api_key => BAD_API_KEY
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
  
    context "#{role} : get /:fake_id" do
      before do
        get "/#{FAKE_ID}", :api_key => @user.api_key
      end
    
      use "return 404 Not Found"
      use "return an empty response body"
    end

    context "#{role} : get /:id" do
      before do
        get "/#{@user.id}", :api_key => @user.api_key
      end

      use "return 200 Ok"
      doc_properties %w(name email role api_key id created_at updated_at)
    end
  end

end
