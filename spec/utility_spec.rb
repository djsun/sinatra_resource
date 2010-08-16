require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../lib/utility')

describe "Helpers" do

  describe "underscore" do
    it "Source" do
      SinatraResource::Utility.underscore("Source").should == "source"
    end

    it "SourceGroup" do
      SinatraResource::Utility.underscore("SourceGroup").should == "source_group"
    end
  end

end
