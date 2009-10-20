class ResourceTestCase

  shared "return an empty response body" do
    test "should return nil" do
      assert_equal nil, parsed_response_body
    end
  end

  shared "return an empty list response body" do
    test "should return []" do
      assert_equal [], parsed_response_body
    end
  end

end
