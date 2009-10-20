require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class CategoriesPostResourceTest < ResourceTestCase

  include DataCatalog

  def app; Categories end

  before do
    @category_count = Category.all.length
    @valid_params = {
      :name => "New Category"
    }
  end

  shared "no new categories" do
    test "should not change number of category documents in database" do
      assert_equal @category_count, Category.all.length
    end
  end

  shared "one new category" do
    test "should add one category document to database" do
      assert_equal @category_count + 1, Category.all.length
    end
  end

  shared "correct Location header" do
    test "should set Location header correctly" do
      base_uri = Config.environment_config["base_uri"]
      path = %(/categories/#{parsed_response_body["id"]})
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
      use "no new categories"
    end

    context "incorrect API key" do
      before do
        post "/", @valid_params.merge(:api_key => BAD_API_KEY)
      end
  
      use "return 401 because the API key is invalid"
      use "no new categories"
    end
  end

  %w(basic).each do |role|
    [:name].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end

        use "return 401 Unauthorized"
        use "no new categories"
      end
    end

    [:id, :created_at, :updated_at, :sources].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 401 Unauthorized"
        use "no new categories"
      end
    end

    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role)
      end
      
      use "return 401 Unauthorized"
      use "no new categories"
    end
  end

  %w(curator admin).each do |role|
    [:name].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end

        use "return 400 Bad Request"
        use "no new categories"
        missing_param missing
      end
    end

    [:id, :created_at, :updated_at, :sources].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 400 Bad Request"
        use "no new categories"
        invalid_param invalid
      end
    end

    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role)
      end
  
      use "return 201 Created"
      use "correct Location header"
      use "one new category"
      doc_properties %w(name id created_at updated_at sources)

      test "should set all fields in database" do
        category = Category.find_by_id(parsed_response_body["id"])
        raise "Cannot find category" unless category
        @valid_params.each_pair do |key, value|
          assert_equal value, category[key]
        end
      end
    end
  end

end
