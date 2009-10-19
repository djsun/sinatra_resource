require File.expand_path(File.dirname(__FILE__) + '/../helpers/model_test_helper')

class UserTest < ModelTestCase
  
  include DataCatalog

  context "User#new" do
    before do
      @required = {
        :name => "Sample User",
        :role => "basic"
      }
    end
  
    context "correct params" do
      before do
        @user = User.new(@required)
      end
      
      test "should be valid" do
        assert_equal true, @user.valid?
      end
      
      test "should not set api_key" do
        assert_equal nil, @user._api_key
      end
    end
    
    [:name, :role].each do |missing|
      context "missing #{missing}" do
        before do
          @user = User.new(@required.delete_if { |k, v| k == missing })
        end
        
        missing_key(:user, missing)
      end
    end

    context "invalid role" do
      before do
        @user = User.new(@required.merge(:role => "owner"))
        # owner is not a 'fixed' role, it is a 'relative' role
      end
    
      test "should be invalid" do
        assert_equal false, @user.valid?
      end

      test "should have errors" do
        @user.valid?
        expected = %(must be in ["basic", "curator", "admin"])
        assert_include expected, @user.errors.errors[:role]
      end
    end

    context "User#create" do
      context "correct params" do
        before do
          @user = User.create(@required)
        end
        
        after do
          @user.destroy
        end
    
        test "should be valid" do
          assert_equal true, @user.valid?
        end
    
        test "should set api_key" do
          assert_not_equal nil, @user._api_key
        end
      end
    end
  end
  
end
