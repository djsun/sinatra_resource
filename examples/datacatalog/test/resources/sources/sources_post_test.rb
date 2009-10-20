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

  shared "no new sources" do
    test "should not change number of source documents in database" do
      assert_equal @source_count, Source.all.length
    end
  end

  shared "one new source" do
    test "should add one source document to database" do
      assert_equal @source_count + 1, Source.all.length
    end
  end
  
  shared "correct Location header" do
    test "should set Location header correctly" do
      base_uri = Config.environment_config["base_uri"]
      path = %(/sources/#{parsed_response_body["id"]})
      expected = URI.join(base_uri, path).to_s
      assert_equal expected, last_response.headers['Location']
    end
  end
  
  context "post /" do
    context "anonymous" do
      before do
        post "/", @valid_params
      end
    
      use "return 401 because the API key is missing"
      use "no new sources"
    end

    context "incorrect API key" do
      before do
        post "/", @valid_params.merge(:api_key => BAD_API_KEY)
      end
  
      use "return 401 because the API key is invalid"
      use "no new sources"
    end
  end

  %w(basic).each do |role|
    [:title, :url].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end

        use "return 401 Unauthorized"
        use "no new sources"
      end
    end

    [:id, :created_at, :updated_at, :categories].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 401 Unauthorized"
        use "no new sources"
      end
    end
  
    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role)
      end
      
      use "return 401 Unauthorized"
      use "no new sources"
    end
  end
  
  %w(curator).each do |role|
    [:title, :url].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end

        use "return 400 Bad Request"
        use "no new sources"
        missing_param missing
      end
    end

    [:raw, :id, :created_at, :updated_at, :categories].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 400 Bad Request"
        use "no new sources"
        invalid_param invalid
      end
    end
  
    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role)
      end
  
      use "return 201 Created"
      use "correct Location header"
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
        use "no new sources"
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
        use "no new sources"
        invalid_param invalid
      end
    end
  
    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role).merge(@extra_admin_params)
      end
  
      use "return 201 Created"
      use "correct Location header"
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
