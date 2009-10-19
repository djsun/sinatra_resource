require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class CategoriesPostResourceTest < ResourceTestCase

  def app; DataCatalog::Categories end

  before do
    @valid_params = {
      :name => "New Category"
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

  %w(basic).each do |role|
    [:name].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end

        use "return 401 Unauthorized"
      end
    end

    [:id, :created_at, :updated_at, :sources].each do |invalid|
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

  %w(curator admin).each do |role|
    [:name].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end

        use "return 400 Bad Request"
        missing_param missing
      end
    end

    [:id, :created_at, :updated_at, :sources].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 400 Bad Request"
        invalid_param invalid
      end
    end

    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role)
      end
  
      use "return 200 Ok"
      doc_properties %w(name id created_at updated_at sources)
    end
  end

end
