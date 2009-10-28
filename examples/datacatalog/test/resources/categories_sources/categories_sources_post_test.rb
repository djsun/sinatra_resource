require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class CategoriesSourcesPostResourceTest < ResourceTestCase

  include DataCatalog

  def app; Categories end
  
  before do
    @category = create_category
    @source = create_source
    @categorization = create_categorization(
      :source_id   => @source.id,
      :category_id => @category.id
    )
    @source_count = Source.all.length
    @valid_params = {
      :title   => "New Source",
      :url     => "http://data.gov/details/123"
    }
    @extra_admin_params = { :raw => { "key" => "value" } }
  end
  
  after do
    @categorization.destroy
    @source.destroy
    @category.destroy
  end
  
  context "post /:id/sources" do
    context "anonymous" do
      before do
        post "/#{@category.id}/sources/"
      end
    
      use "return 401 because the API key is missing"
      use "no change in source count"
    end
  
    context "incorrect API key" do
      before do
        post "/#{@category.id}/sources/", :api_key => BAD_API_KEY
      end
      
      use "return 401 because the API key is invalid"
      use "no change in source count"
    end
  end
  
  %w(basic).each do |role|
    context "#{role} : post /:fake_id/sources" do
      before do
        post "/#{FAKE_ID}/sources/", :api_key => api_key_for(role)
      end
  
      use "return 404 Not Found with empty response body"
      use "no change in source count"
    end
  
    context "#{role} : post /:id/sources" do
      before do
        post "/#{@category.id}/sources/", :api_key => api_key_for(role)
      end
    
      use "return 401 because the API key is unauthorized"
      use "no change in source count"
    end
  end

  %w(curator).each do |role|
    context "#{role} : post /:fake_id/sources" do
      before do
        post "/#{FAKE_ID}/sources/", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
      use "no change in source count"
    end
  
    [:title, :url].each do |missing|
      context "#{role} : post /:id/sources/ but missing #{missing}" do
        before do
          post "/#{@category.id}/sources/",
            valid_params_for(role).delete_if { |k, v| k == missing }
        end
        
        use "return 400 Bad Request"
        use "no change in source count"
        missing_param missing
      end
    end

    [:raw, :id, :created_at, :updated_at, :junk].each do |invalid|
      context "#{role} : post /:id/sources/ but with #{invalid}" do
        before do
          post "/#{@category.id}/sources/", valid_params_for(role).
            merge(invalid => 9)
        end
      
        use "return 400 Bad Request"
        use "no change in source count"
        invalid_param invalid
      end
    end

    context "#{role} : post /:id/sources with valid params" do
      before do
        post "/#{@category.id}/sources/", valid_params_for(role)
      end

      after do
        Source.find_by_id(parsed_response_body["id"]).destroy
      end
      
      use "return 201 Created"
      location_header "sources"
      use "one new source"
      doc_properties %w(title url raw id created_at updated_at)
      
      test "source connected to category" do
        source = Source.find_by_id(parsed_response_body["id"])
        assert_equal [@category], source.categories
      end
    end
  end

  %w(admin).each do |role|
    context "#{role} : post /:fake_id/sources" do
      before do
        post "/#{FAKE_ID}/sources/",
          valid_params_for(role).merge(@extra_admin_params)
      end
    
      use "return 404 Not Found with empty response body"
      use "no change in source count"
    end
  
    [:title, :url].each do |missing|
      context "#{role} : post /:id/sources/ but missing #{missing}" do
        before do
          post "/#{@category.id}/sources/",
            valid_params_for(role).merge(@extra_admin_params).
              delete_if { |k, v| k == missing }
        end
        
        use "return 400 Bad Request"
        use "no change in source count"
        missing_param missing
      end
    end

    [:id, :created_at, :updated_at, :junk].each do |invalid|
      context "#{role} : post /:id/sources/ but with #{invalid}" do
        before do
          post "/#{@category.id}/sources/", valid_params_for(role).
            merge(@extra_admin_params).merge(invalid => 9)
        end
      
        use "return 400 Bad Request"
        use "no change in source count"
        invalid_param invalid
      end
    end

    context "#{role} : post /:id/sources with valid params" do
      before do
        post "/#{@category.id}/sources/",
          valid_params_for(role).merge(@extra_admin_params)
      end

      after do
        Source.find_by_id(parsed_response_body["id"]).destroy
      end
      
      use "return 201 Created"
      location_header "sources"
      use "one new source"
      doc_properties %w(title url raw id created_at updated_at)
      
      test "source connected to category" do
        source = Source.find_by_id(parsed_response_body["id"])
        assert_equal [@category], source.categories
      end
    end
  end
  
end
