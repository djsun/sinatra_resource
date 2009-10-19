module RequestHelpers

  def parsed_response_body
    s = last_response.body
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
        puts("\n-- " + last_response.body.inspect) unless parsed_response_body
        assert parsed_response_body
        assert_include "errors", parsed_response_body
        assert_include s.to_s, parsed_response_body["errors"]["invalid_params"]
      end
    end
    
    def missing_param(s)
      test "should report missing #{s}" do
        puts("\n-- " + last_response.body.inspect) unless parsed_response_body
        assert parsed_response_body
        assert_include "errors", parsed_response_body
        assert_include "can't be empty", parsed_response_body["errors"][s.to_s]
      end
    end
    
    def unchanged(symbol)
      test "should not change #{symbol}" do
        original = instance_variable_get("@#{symbol}_copy")
        document = instance_variable_get("@#{symbol}")
        assert_equal original, document
      end
    end
  end
  
end
