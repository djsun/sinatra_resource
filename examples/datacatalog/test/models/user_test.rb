require File.expand_path(File.dirname(__FILE__) + '/../helpers/model_test_helper')

class UserTest < ModelTestCase
  
  include DataCatalog

  context "User#new" do
    before do
      @required = {}
    end
  
    context "correct params" do
      before do
        @user = User.new(@required)
      end
      
      test "should be valid" do
        assert_equal true, @user.valid?
      end
      
      test "should not set api_key" do
        assert_equal nil, @user.api_key
      end
    end

    context "User#create" do
      before do
        @required = {}
      end

      context "correct params" do
        before do
          @user = User.create(@required)
        end

        test "should be valid" do
          assert_equal true, @user.valid?
        end

        test "should set api_key" do
          assert_not_equal nil, @user.api_key
        end
      end
    end
  end
  
end
