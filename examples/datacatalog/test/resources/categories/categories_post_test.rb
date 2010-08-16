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

  context "post /" do
    context "anonymous" do
      before do
        post "/", @valid_params
      end

      use "return 401 because the API key is missing"
      use "no change in category count"
    end

    context "incorrect API key" do
      before do
        post "/", @valid_params.merge(:api_key => BAD_API_KEY)
      end

      use "return 401 because the API key is invalid"
      use "no change in category count"
    end
  end

  %w(basic).each do |role|
    [:name].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end

        use "return 401 because the API key is unauthorized"
        use "no change in category count"
      end
    end

    [:id, :created_at, :updated_at, :sources, :junk].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).merge(invalid => 9)
        end

        use "return 401 because the API key is unauthorized"
        use "no change in category count"
      end
    end

    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role)
      end

      use "return 401 because the API key is unauthorized"
      use "no change in category count"
    end
  end

  %w(curator admin).each do |role|
    [:name].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end

        use "return 400 Bad Request"
        use "no change in category count"
        missing_param missing
      end
    end

    [:id, :created_at, :updated_at, :sources, :junk].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).merge(invalid => 9)
        end

        use "return 400 Bad Request"
        use "no change in category count"
        invalid_param invalid
      end
    end

    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role)
      end

      after do
        Category.find_by_id(parsed_response_body["id"]).destroy
      end

      use "return 201 Created"
      location_header "categories"
      use "one new category"
      doc_properties %w(name log id created_at updated_at sources)

      test "should set all fields in database" do
        category = Category.find_by_id(parsed_response_body["id"])
        raise "Cannot find category" unless category
        @valid_params.each_pair do |key, value|
          assert_equal value, category[key]
        end
      end

      test "callbacks should work" do
        assert_equal "before_create after_create", parsed_response_body["log"]
      end
    end
  end

end
