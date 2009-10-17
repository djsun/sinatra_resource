require File.expand_path(File.dirname(__FILE__) + '/../helpers/model_test_helper')

class UserTest < ModelTestCase
  
  include DataCatalog

  context "User" do
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
    end
  end
  
end
