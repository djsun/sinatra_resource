require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class CategoriesPostResourceTest < ResourceTestCase

  def app; DataCatalog::Categories end
  
  context "post /:id" do
    context "anonymous" do
      before do
        post "/"
      end
    
      use "return 401 because the API key is missing"
    end

    context "incorrect API key" do
      before do
        post "/", :api_key => BAD_API_KEY
      end
  
      use "return 401 because the API key is invalid"
    end
  end

  %w(basic).each do |role|
    context "#{role} : post / missing name" do
      before do
        post "/", :api_key => api_key_for(role)
      end
  
      use "return 401 Unauthorized"
    end

    # context "#{role} : post / with valid params" do
    #   before do
    #     post "/",
    #       :api_key => api_key_for(role),
    #       :name    => "New Category"
    #   end
    #   
    #   use "return 401 Unauthorized"
    # end
  end

  %w(curator admin).each do |role|
  end

end
