require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesPostResourceTest < ResourceTestCase
  
  include DataCatalog

  def app; Sources end
  
  before do
    @source_count = Source.all.length
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
      use "no change in source count"
    end

    context "incorrect API key" do
      before do
        post "/", @valid_params.merge(:api_key => BAD_API_KEY)
      end
  
      use "return 401 because the API key is invalid"
      use "no change in source count"
    end
  end

  %w(basic).each do |role|
    [:title, :url].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end

        use "return 401 because the API key is unauthorized"
        use "no change in source count"
      end
    end

    [:id, :created_at, :updated_at, :categories].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 401 because the API key is unauthorized"
        use "no change in source count"
      end
    end
  
    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role)
      end
      
      use "return 401 because the API key is unauthorized"
      use "no change in source count"
    end
  end
  
  %w(curator).each do |role|
    [:title, :url].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end

        use "return 400 Bad Request"
        use "no change in source count"
        missing_param missing
      end
    end

    [:raw, :id, :created_at, :updated_at, :categories].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 400 Bad Request"
        use "no change in source count"
        invalid_param invalid
      end
    end
  
    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role)
      end

      after do
        Source.find_by_id(parsed_response_body["id"]).destroy
      end
  
      use "return 201 Created"
      location_header "sources"
      use "one new source"
      doc_properties %w(title url raw id created_at updated_at categories)

      test "should set all fields in database" do
        source = Source.find_by_id(parsed_response_body["id"])
        raise "Cannot find source" unless source
        @valid_params.each_pair do |key, value|
          assert_equal value, source[key]
        end
      end
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
        use "no change in source count"
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
        use "no change in source count"
        invalid_param invalid
      end
    end
  
    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role).merge(@extra_admin_params)
      end

      after do
        Source.find_by_id(parsed_response_body["id"]).destroy
      end
  
      use "return 201 Created"
      location_header "sources"
      use "one new source"
      doc_properties %w(title url raw id created_at updated_at categories)

      test "should set all fields in database" do
        source = Source.find_by_id(parsed_response_body["id"])
        raise "Cannot find source" unless source
        @valid_params.merge(@extra_admin_params).each_pair do |key, value|
          assert_equal value, source[key]
        end
      end
    end
  end

end
