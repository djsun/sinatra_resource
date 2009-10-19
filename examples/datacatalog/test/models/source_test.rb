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

    [:title, :url].each do |missing|
      context "missing #{missing}" do
        before do
          @source = Source.new(@required.delete_if { |k, v| k == missing })
        end
        
        missing_key(:source, missing)
      end
    end

  end
  
end
