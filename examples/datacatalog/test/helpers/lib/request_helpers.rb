module RequestHelpers

  def parsed_response_body
    s = last_response.body
    # puts "\n== parsed_response_body"
    # puts "s : #{s.inspect}"
    if s == ""
      nil
    else
      Crack::JSON.parse(s)
    end
  end
  
  def assert_properties(correct, parsed_document)
    correct.each do |property|
      assert_include property, parsed_document
    end
    assert_equal [], parsed_document.keys - correct
  end

  def self.included(includee)
    includee.extend(ClassMethods)
  end
  
  module ClassMethods
    def doc_properties(correct)
      test "document should only have correct attributes" do
        assert_properties(correct, parsed_response_body)
      end
    end

    def docs_properties(correct)
      test "documents should only have correct attributes" do
        parsed_response_body.each do |parsed|
          assert_properties(correct, parsed)
        end
      end
    end
    
    def invalid_param(s)
      test "should report #{s} as invalid" do
        assert_include s.to_s, parsed_response_body["errors"]["invalid_params"]
      end
    end
    
    def missing_param(s)
      test "should report missing #{s}" do
        assert_include "can't be empty", parsed_response_body["errors"][s.to_s]
      end
    end
  end
  
end
