require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class UsersDeleteResourceTest < ResourceTestCase

  include DataCatalog

  def app; Users end

  before do
    @user = create_user
    @user_count = User.all.length
  end

  after do
    @user.destroy
  end

  context "delete /:id" do
    context "anonymous" do
      before do
        delete "/#{@user.id}"
      end

      use "return 401 because the API key is missing"
      use "no change in user count"
    end

    context "incorrect API key" do
      before do
        delete "/#{@user.id}", :api_key => BAD_API_KEY
      end

      use "return 401 because the API key is invalid"
      use "no change in user count"
    end
  end

  %w(basic curator).each do |role|
    context "#{role} : delete /:fake_id" do
      before do
        delete "/#{FAKE_ID}", :api_key => api_key_for(role)
      end

      use "return 401 because the API key is unauthorized"
      use "no change in user count"
    end

    context "#{role} : delete /:id" do
      before do
        delete "/#{@user.id}",
          :api_key => api_key_for(role),
          :key     => "value"
      end

      use "return 401 because the API key is unauthorized"
      use "no change in user count"
    end

    context "#{role} : delete /:id" do
      before do
        delete "/#{@user.id}", :api_key => api_key_for(role)
      end

      use "return 401 because the API key is unauthorized"
      use "no change in user count"
    end
  end

  context "owner" do
    context "delete /:id" do
      before do
        delete "/#{@user.id}",
          :api_key => @user._api_key,
          :key     => "value"
      end

      use "return 400 because params were not empty"
      use "no change in user count"
    end

    context "delete /:id" do
      before do
        delete "/#{@user.id}", :api_key => @user._api_key
      end

      use "return 204 No Content"
      use "one less user"
    end
  end

  %(admin).each do |role|
    context "#{role} : delete /:fake_id" do
      before do
        delete "/#{FAKE_ID}", :api_key => api_key_for(role)
      end

      use "return 404 Not Found with empty response body"
      use "no change in user count"
    end

    context "#{role} : delete /:id" do
      before do
        delete "/#{@user.id}",
          :api_key => api_key_for(role),
          :key     => "value"
      end

      use "return 400 because params were not empty"
      use "no change in user count"
    end

    context "#{role} : delete /:id" do
      before do
        delete "/#{@user.id}", :api_key => api_key_for(role)
      end

      use "return 204 No Content"
      use "one less user"
    end
  end

end
