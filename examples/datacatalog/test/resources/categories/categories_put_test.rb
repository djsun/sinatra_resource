require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class CategoriesPutResourceTest < ResourceTestCase

  include DataCatalog

  def app; Categories end

  before do
    @category = create_category
    @category_copy = @category.dup
    @valid_params = {
      :name => "Changed Category"
    }
  end

  after do
    @category.destroy
  end
  
  context "put /:id" do
    context "anonymous" do
      before do
        put "/#{@category.id}", @valid_params
      end
    
      use "return 401 because the API key is missing"
      use "category unchanged"
    end
  
    context "incorrect API key" do
      before do
        put "/#{@category.id}", @valid_params.merge(:api_key => BAD_API_KEY)
      end
  
      use "return 401 because the API key is invalid"
      use "category unchanged"
    end
  end

  %w(basic).each do |role|
    [:created_at, :updated_at, :sources, :junk].each do |invalid|
      context "#{role} : put /:id but with #{invalid}" do
        before do
          put "/#{@category.id}", valid_params_for(role).merge(invalid => 9)
        end
      
        use "return 401 because the API key is unauthorized"
        use "category unchanged"
      end
    end

    [:name].each do |erase|
      context "#{role} : put /:id but blanking out #{erase}" do
        before do
          put "/#{@category.id}", valid_params_for(role).merge(erase => "")
        end
      
        use "return 401 because the API key is unauthorized"
        use "category unchanged"
      end
    end

    context "#{role} : put /:id with no params" do
      before do
        put "/#{@category.id}", :api_key => api_key_for(role)
      end

      use "return 401 because the API key is unauthorized"
      use "category unchanged"
    end

    context "#{role} : put /:fake_id with valid params" do
      before do
        put "/#{FAKE_ID}", valid_params_for(role)
      end
      
      use "return 401 because the API key is unauthorized"
      use "category unchanged"
    end

    context "#{role} : put /:id with valid params" do
      before do
        put "/#{@category.id}", valid_params_for(role)
      end
      
      use "return 401 because the API key is unauthorized"
      use "category unchanged"
    end
  end
  
  %w(curator admin).each do |role|
    [:created_at, :updated_at, :sources, :junk].each do |invalid|
      context "#{role} : put /:id but with #{invalid}" do
        before do
          put "/#{@category.id}", valid_params_for(role).merge(invalid => 9)
        end
      
        use "return 400 Bad Request"
        use "category unchanged"
        invalid_param invalid
      end
    end

    [:name].each do |erase|
      context "#{role} : put /:id but blanking out #{erase}" do
        before do
          put "/#{@category.id}", valid_params_for(role).merge(erase => "")
        end
      
        use "return 400 Bad Request"
        use "category unchanged"
        missing_param erase
      end
    end

    context "#{role} : put /:id with no params" do
      before do
        put "/#{@category.id}", :api_key => api_key_for(role)
      end

      use "return 400 because no params were given"
      use "category unchanged"
    end

    context "#{role} : put /:fake_id with valid params" do
      before do
        put "/#{FAKE_ID}", valid_params_for(role)
      end
      
      use "return 404 Not Found with empty response body"
      use "category unchanged"
    end

    context "#{role} : put /:id with valid params" do
      before do
        put "/#{@category.id}", valid_params_for(role)
      end
      
      use "return 200 Ok"
      doc_properties %w(name log id created_at updated_at sources)
    
      test "should change all fields in database" do
        category = Category.find_by_id(@category.id)
        @valid_params.each_pair do |key, value|
          assert_equal value, category[key]
        end
      end
      
      test "callbacks should work" do
        assert_equal "before_update after_update", parsed_response_body["log"]
      end
    end
  end

end
