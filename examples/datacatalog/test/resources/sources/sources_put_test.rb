require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesPutResourceTest < ResourceTestCase

  include DataCatalog

  def app; Sources end

  before do
    @source = create_source
    @source_copy = @source.dup
    @valid_params = {
      :title   => "Changed Source",
      :url     => "http://updated.com/details/7"
    }
    @extra_admin_params = { :raw => { "key" => "value" } }
  end

  after do
    @source.destroy
  end
  
  shared "source unchanged" do
    test "should not change source in database" do
      assert_equal @source_copy, Source.find_by_id(@source.id)
    end
  end
  
  context "put /:id" do
    context "anonymous" do
      before do
        put "/#{@source.id}", @valid_params
      end
    
      use "return 401 because the API key is missing"
      use "source unchanged"
    end
  
    context "incorrect API key" do
      before do
        put "/#{@source.id}", @valid_params.merge(:api_key => BAD_API_KEY)
      end
  
      use "return 401 because the API key is invalid"
      use "source unchanged"
    end
  end
  
  %w(basic).each do |role|
    [:id, :created_at, :updated_at, :categories].each do |invalid|
      context "#{role} : put / but with #{invalid}" do
        before do
          put "/#{@source.id}", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 401 because the API key is unauthorized"
        use "source unchanged"
      end
    end
  
    [:title, :url].each do |erase|
      context "#{role} : put / but blanking out #{erase}" do
        before do
          put "/#{@source.id}", valid_params_for(role).merge(erase => "")
        end
  
        use "return 401 because the API key is unauthorized"
        use "source unchanged"
      end
    end
  
    [:title, :url].each do |missing|
      context "#{role} : put /:id without #{missing}" do
        before do
          put "/#{@source.id}", valid_params_for(role).delete_if { |k, v| k == missing }
        end
  
        use "return 401 because the API key is unauthorized"
        use "source unchanged"
      end
    end
  
    context "#{role} : put /:id with valid params" do
      before do
        put "/#{@source.id}", valid_params_for(role)
      end
      
      use "return 401 because the API key is unauthorized"
      use "source unchanged"
    end
  end
  
  %w(curator).each do |role|
    [:raw, :created_at, :updated_at, :categories].each do |invalid|
      context "#{role} : put / but with #{invalid}" do
        before do
          put "/#{@source.id}", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 400 Bad Request"
        use "source unchanged"
        invalid_param invalid
      end
    end

    [:title, :url].each do |erase|
      context "#{role} : put / but blanking out #{erase}" do
        before do
          put "/#{@source.id}", valid_params_for(role).merge(erase => "")
        end
      
        use "return 400 Bad Request"
        use "source unchanged"
        missing_param erase
      end
    end  

    [:title, :url].each do |missing|
      context "#{role} : put /:id without #{missing}" do
        before do
          put "/#{@source.id}", valid_params_for(role).delete_if { |k, v| k == missing }
        end
      
        use "return 200 Ok"
        doc_properties %w(title url raw id created_at updated_at categories)

        test "should change correct fields in database" do
          source = Source.find_by_id(@source.id)
          @valid_params.each_pair do |key, value|
            assert_equal(value, source[key]) if key != missing
          end
          assert_equal @source_copy[missing], source[missing]
        end
      end
    end

    context "#{role} : put /:id with valid params" do
      before do
        put "/#{@source.id}", valid_params_for(role)
      end
      
      use "return 200 Ok"
      doc_properties %w(title url raw id created_at updated_at categories)

      test "should change correct fields in database" do
        source = Source.find_by_id(@source.id)
        @valid_params.each_pair do |key, value|
          assert_equal value, source[key]
        end
      end
    end
  end
  
  %w(admin).each do |role|
    [:created_at, :updated_at, :categories].each do |invalid|
      context "#{role} : put / but with #{invalid}" do
        before do
          put "/#{@source.id}", valid_params_for(role).
            merge(@extra_admin_params).merge(invalid => 9)
        end
  
        use "return 400 Bad Request"
        use "source unchanged"
        invalid_param invalid
      end
    end

    [:title, :url].each do |erase|
      context "#{role} : put / but blanking out #{erase}" do
        before do
          put "/#{@source.id}", valid_params_for(role).
            merge(@extra_admin_params).merge(erase => "")
        end
      
        use "return 400 Bad Request"
        use "source unchanged"
        missing_param erase
      end
    end  

    context "#{role} : put /:id with no params" do
      before do
        put "/#{@source.id}", :api_key => api_key_for(role)
      end

      use "return 400 because no params were given"
      use "source unchanged"
    end

    [:title, :url].each do |missing|
      context "#{role} : put /:id without #{missing}" do
        before do
          put "/#{@source.id}", valid_params_for(role).
            merge(@extra_admin_params).delete_if { |k, v| k == missing }
        end
      
        use "return 200 Ok"
        doc_properties %w(title url raw id created_at updated_at categories)

        test "should change correct fields in database" do
          source = Source.find_by_id(@source.id)
          @valid_params.merge(@extra_admin_params).each_pair do |key, value|
            assert_equal(value, source[key]) if key != missing
          end
          assert_equal @source_copy[missing], source[missing]
        end
      end
    end

    context "#{role} : put /:id with valid params" do
      before do
        put "/#{@source.id}", valid_params_for(role).merge(@extra_admin_params)
      end
      
      use "return 200 Ok"
      doc_properties %w(title url raw id created_at updated_at categories)

      test "should change all fields in database" do
        source = Source.find_by_id(@source.id)
        @valid_params.merge(@extra_admin_params).each_pair do |key, value|
          assert_equal value, source[key]
        end
      end
    end
  end

end
