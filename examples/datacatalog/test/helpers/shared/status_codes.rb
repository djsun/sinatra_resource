class ResourceTestCase
  
  shared "return 200 Ok" do
    test "status should be 200 Ok" do
      assert_equal 200, last_response.status
    end
  end

  shared "return 201 Created" do
    test "status should be 201 Created" do
      assert_equal 201, last_response.status
    end
    
    test "location header should start with http://localhost" do
      assert_include "Location", last_response.headers
      generic_uri = %r{^http://localhost}
      assert_match generic_uri, last_response.headers["Location"]
    end
  end

  shared "return 204 No Content" do
    test "status should be 204 No Content" do
      assert_equal 204, last_response.status
    end
    
    use "return an empty response body"
  end

  shared "return 400 Bad Request" do
    test "status should be 400 Bad Request" do
      assert_equal 400, last_response.status
    end
  end

  shared "return 401 Unauthorized" do
    test "status should be 401 Unauthorized" do
      assert_equal 401, last_response.status
    end
  end

  shared "return 403 Forbidden" do
    test "status should be 403 Forbidden" do
      assert_equal 403, last_response.status
    end
  end

  shared "return 404 Not Found" do
    test "status should be 404 Not Found" do
      assert_equal 404, last_response.status
    end
  end

  shared "return 404 Not Found with empty response body" do
    use "return 404 Not Found"
    
    use "return an empty response body"
  end

  shared "return 409 Conflict" do
    test "status should be 409 Conflict" do
      assert_equal 409, last_response.status
    end
  end

end
