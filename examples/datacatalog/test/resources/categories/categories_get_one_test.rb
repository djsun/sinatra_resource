require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class CategoriesGetOneResourceTest < ResourceTestCase

  def app; DataCatalog::Categories end
  
  before do
    @category = create_category
  end
  
  after do
    @category.destroy
  end

  context "get /:id" do
    context "anonymous" do
      before do
        get "/#{@category.id}"
      end
    
      use "return 401 because the API key is missing"
    end

    context "incorrect API key" do
      before do
        get "/#{@category.id}", :api_key => BAD_API_KEY
      end
  
      use "return 401 because the API key is invalid"
    end
  end

  %w(basic curator admin).each do |role|
    before do
      @the_user = create_user(:role => role)
    end
    
    after do
      @the_user.destroy
    end
  
    context "#{role} : get /:fake_id" do
      before do
        get "/#{FAKE_ID}", :api_key => @the_user.api_key
      end
    
      use "return 404 Not Found"
      use "return an empty response body"
    end

    context "#{role} : get /:id" do
      before do
        get "/#{@category.id}", :api_key => @the_user.api_key
      end

      use "return 200 Ok"
      doc_properties %w(name id created_at updated_at)
    end
  end

end
