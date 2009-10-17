require File.expand_path(File.dirname(__FILE__) + '/../helpers/model_test_helper')

class SourceTest < ModelTestCase
  
  include DataCatalog

  context "Source" do
    before do
      @required = {
        :title => "Treasury 2009 Summary",
        :url   => "http://moneybags.gov/data/2009"
      }
    end
  
    context "correct params" do
      before do
        @source = Source.new(@required)
      end
      
      test "should be valid" do
        assert_equal true, @source.valid?
      end
    end

    context "missing name" do
      before do
        @source = Source.new(@required.merge(:title => ""))
      end
    
      test "should be invalid" do
        assert_equal false, @source.valid?
      end

      test "should have errors" do
        @source.valid?
        expected = "can't be empty"
        assert_include expected, @source.errors.errors[:title]
      end
    end
  end
  
end
