require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesPostResourceTest < ResourceTestCase

  def app; DataCatalog::Sources end
  
  before do
    @valid_params = {
      :title   => "New Source",
      :url     => "http://data.gov/details/123"
    }
    @extra_admin_params = { :raw => { "key" => "value" } }
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
    [:title, :url].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end

        use "return 401 Unauthorized"
      end
    end

    [:id, :created_at, :updated_at, :categories].each do |invalid|
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
  
  %w(curator).each do |role|
    [:title, :url].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end

        use "return 400 Bad Request"
        missing_param missing
      end
    end

    [:raw, :id, :created_at, :updated_at, :categories].each do |invalid|
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
      doc_properties %w(title url raw id created_at updated_at categories)
    end
  end

  %w(admin).each do |role|
    [:title, :url].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).
            merge(@extra_admin_params).delete_if { |k, v| k == missing }
        end

        use "return 400 Bad Request"
        missing_param missing
      end
    end

    [:id, :created_at, :updated_at, :categories].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).
            merge(@extra_admin_params).merge(invalid => 9)
        end
  
        use "return 400 Bad Request"
        invalid_param invalid
      end
    end
  
    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role).merge(@extra_admin_params)
      end
  
      use "return 200 Ok"
      doc_properties %w(title url raw id created_at updated_at categories)
    end
  end

end
