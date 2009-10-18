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

  end
  
end
