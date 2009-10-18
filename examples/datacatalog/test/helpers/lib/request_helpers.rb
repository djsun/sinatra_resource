module RequestHelpers

  def parsed_response_body
    s = last_response.body
    if s == ""
      nil
    else
      Crack::JSON.parse(s)
    end
  end

  def self.included(includee)
    includee.extend(ClassMethods)
  end
  
  module ClassMethods
    def properties(correct)
      test "body should only have correct attributes" do
        parsed = parsed_response_body
        correct.each do |property|
          assert_include property, parsed
        end
        assert_equal [], parsed.keys - correct
      end
    end
  end
  
end
