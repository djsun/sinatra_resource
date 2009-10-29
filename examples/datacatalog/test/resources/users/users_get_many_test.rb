require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class UsersGetManyResourceTest < ResourceTestCase

  include DataCatalog

  def app; Users end

  before do
    unless 3 == (c = User.count)
      raise "Expected 3 for User.count, found #{c}"
    end
    @users = 3.times.map do |i|
      create_user(
        :name  => "User #{i}",
        :email => "user-#{i}@inter.net"
      )
    end
  end
  
  after do
    @users.each { |x| x.destroy } if @users
  end
  
  NAMES = [
    "admin User",
    "basic User",
    "curator User",
    "User 0",
    "User 1",
    "User 2"
  ].sort
  
  EMAILS = %w(
    admin-user@inter.net
    basic-user@inter.net
    curator-user@inter.net
    user-0@inter.net
    user-1@inter.net
    user-2@inter.net
  ).sort

  context "get /" do
    context "anonymous" do
      before do
        get "/"
      end
    
      use "return 401 because the API key is missing"
    end
  
    context "incorrect API key" do
      before do
        get "/", :api_key => BAD_API_KEY
      end
  
      use "return 401 because the API key is invalid"
    end
  end
  
  %w(basic curator).each do |role|
    context "#{role} : get /" do
      before do
        get "/", :api_key => api_key_for(role)
      end
  
      use "return 200 Ok"
      
      test "body should have 6 users" do
        assert_equal 6, parsed_response_body.length
      end
      
      test "body should have correct names" do
        actual = parsed_response_body.map { |e| e["name"] }
        assert_equal NAMES, actual.sort
      end

      test "body elements should be correct" do
        parsed_response_body.each do |element|
          if element["id"] == user_for(role).id
            assert_properties(%w(name email role _api_key token
              id created_at updated_at), element)
          else
            assert_properties(%w(name id created_at updated_at), element)
          end
        end
      end
    end
  end
  
  %w(admin).each do |role|
    context "#{role} : get /" do
      before do
        get "/", :api_key => api_key_for(role)
      end
  
      use "return 200 Ok"
      
      test "body should have 6 users" do
        assert_equal 6, parsed_response_body.length
      end
      
      test "body should have correct names" do
        actual = parsed_response_body.map { |e| e["name"] }
        assert_equal NAMES, actual.sort
      end
  
      test "body should have correct emails" do
        actual = parsed_response_body.map { |e| e["email"] }
        assert_equal EMAILS, actual.sort
      end
      
      docs_properties %w(name email role _api_key token id created_at updated_at)
    end
  end
  
end
