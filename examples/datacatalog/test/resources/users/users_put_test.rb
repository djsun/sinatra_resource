require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class UsersPutResourceTest < ResourceTestCase

  include DataCatalog

  def app; Users end

  before do
    @user = create_user
    @user_copy = @user.dup
    @valid_params = {
      :name   => "Changed User",
      :role   => "curator"
    }
    @extra_admin_params = {
      :_api_key => "222200004444"
    }
  end

  after do
    @user.destroy
  end
  
  context "put /:id" do
    context "anonymous" do
      before do
        put "/#{@user.id}", @valid_params
      end
    
      use "return 401 because the API key is missing"
      use "user unchanged"
    end
  
    context "incorrect API key" do
      before do
        put "/#{@user.id}", @valid_params.merge(:api_key => BAD_API_KEY)
      end
  
      use "return 401 because the API key is invalid"
      use "user unchanged"
    end
  end
  
  %w(basic curator).each do |role|
    [:created_at, :updated_at].each do |invalid|
      context "#{role} : put / but with #{invalid}" do
        before do
          put "/#{@user.id}", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 401 because the API key is unauthorized"
        use "user unchanged"
      end
    end

    [:name, :role].each do |erase|
      context "#{role} : put / but blanking out #{erase}" do
        before do
          put "/#{@user.id}", valid_params_for(role).merge(erase => "")
        end
      
        use "return 401 because the API key is unauthorized"
        use "user unchanged"
      end
    end

    [:name, :role].each do |missing|
      context "#{role} : put /:id without #{missing}" do
        before do
          put "/#{@user.id}", valid_params_for(role).
            delete_if { |k, v| k == missing }
        end
      
        use "return 401 because the API key is unauthorized"
        use "user unchanged"
      end
    end

    context "#{role} : put /:id with valid params" do
      before do
        put "/#{@user.id}", valid_params_for(role)
      end
    
      use "return 401 because the API key is unauthorized"
      use "user unchanged"
    end
  end

  %w(admin).each do |role|
    [:created_at, :updated_at].each do |invalid|
      context "#{role} : put / but with #{invalid}" do
        before do
          put "/#{@user.id}", valid_params_for(role).
            merge(@extra_admin_params).merge(invalid => 9)
        end
  
        use "return 400 Bad Request"
        use "user unchanged"
        invalid_param invalid
      end
    end

    [:name, :role].each do |erase|
      context "#{role} : put / but blanking out #{erase}" do
        before do
          put "/#{@user.id}", valid_params_for(role).
            merge(@extra_admin_params).merge(erase => "")
        end
      
        use "return 400 Bad Request"
        use "user unchanged"
        missing_param erase
      end
    end

    context "#{role} : put /:id with no params" do
      before do
        put "/#{@user.id}", :api_key => api_key_for(role)
      end

      use "return 400 because no params were given"
      use "user unchanged"
    end

    [:name, :role].each do |missing|
      context "#{role} : put /:id without #{missing}" do
        before do
          put "/#{@user.id}", valid_params_for(role).
            merge(@extra_admin_params).delete_if { |k, v| k == missing }
        end
      
        use "return 200 Ok"
        doc_properties %w(name email role _api_key id created_at updated_at)
  
        test "should change correct fields in database" do
          user = User.find_by_id(@user.id)
          @valid_params.merge(@extra_admin_params).each_pair do |key, value|
            assert_equal(value, user[key]) if key != missing
          end
          assert_equal @user_copy[missing], user[missing]
        end
      end
    end

    context "#{role} : put /:id with valid params" do
      before do
        put "/#{@user.id}", valid_params_for(role).merge(@extra_admin_params)
      end
      
      use "return 200 Ok"
      doc_properties %w(name email role _api_key id created_at updated_at)
  
      test "should change all fields in database" do
        user = User.find_by_id(@user.id)
        @valid_params.merge(@extra_admin_params).each_pair do |key, value|
          assert_equal value, user[key]
        end
      end
    end
  end

end
