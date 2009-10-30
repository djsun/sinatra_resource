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
        assert_include s.to_s, parsed_response_body["errors"]["invalid_params"]
      end
    end
    
    def missing_param(s)
      test "should report missing #{s}" do
        assert_include "can't be empty", parsed_response_body["errors"][s.to_s]
      end
    end

    def location_header(path)
      test "should set Location header correctly" do
        base_uri = Config.environment_config["base_uri"]
        path = %(#{path}/#{parsed_response_body["id"]})
        expected = URI.join(base_uri, path).to_s
        assert_equal expected, last_response.headers['Location']
      end
    end
    
    def nested_location_header(parent_path, parent_ivar, child_path)
      test "should set Location header correctly" do
        base_uri = Config.environment_config["base_uri"]
        parent = instance_variable_get("@#{parent_ivar}")
        raise Error unless parent
        path = parent_path + '/' + parent.id + '/' + child_path + '/' +
          parsed_response_body["id"]
        expected = URI.join(base_uri, path).to_s
        assert_equal expected, last_response.headers['Location']
      end
    end
    

  end
  
end
