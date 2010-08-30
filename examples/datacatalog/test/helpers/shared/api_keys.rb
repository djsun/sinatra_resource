class ResourceTestCase

  shared "return 400 because no params were given" do
    use "return 400 Bad Request"

    test "body should say no params were given" do
      assert_include "errors", parsed_response_body
      assert_include "no_params", parsed_response_body["errors"]
    end
  end

  shared "return 400 because invalid params were present" do
    use "return 400 Bad Request"

    test "body should say invalid params were present" do
      assert_include "errors", parsed_response_body
      assert_include "invalid_params", parsed_response_body["errors"]
    end
  end

  shared "return 401 because the API key is invalid" do
    use "return 401 Unauthorized"

    test "body should say the API key is invalid" do
      assert_include "errors", parsed_response_body
      assert_include "invalid_api_key", parsed_response_body["errors"]
    end
  end

  shared "return 401 because the API key is missing" do
    use "return 401 Unauthorized"

    test "body should say the API key is missing" do
      assert_include "errors", parsed_response_body
      assert_include "missing_api_key", parsed_response_body["errors"]
    end
  end

  shared "return 401 because the API key is unauthorized" do
    use "return 401 Unauthorized"

    test "body should say the API key is unauthorized" do
      assert_include "errors", parsed_response_body
      assert_include "unauthorized_api_key", parsed_response_body["errors"]
    end
  end

end
