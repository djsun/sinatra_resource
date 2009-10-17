require File.expand_path(File.dirname(__FILE__) + '/../helpers/model_test_helper')

class UserTest < Test::Unit::TestCase
  
  include DataCatalog

  context "User" do
    before do
      @required = {}
    end
  
    context "correct params" do
      before do
        @source = User.new(@required)
      end
      
      test "should be valid" do
        assert_equal true, @source.valid?
      end
    end
  end
  
end
