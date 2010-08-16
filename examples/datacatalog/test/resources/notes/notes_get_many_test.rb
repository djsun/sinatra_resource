require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class NotesGetManyResourceTest < ResourceTestCase

  include DataCatalog

  def app; Notes end

  before do
    Note.destroy_all unless Note.count == 0
    @users = 3.times.map do |i|
      create_user(
        :name => "User #{i}"
      )
    end
    @notes = 3.times.map do |i|
      create_note(
        :text    => "Note #{i}",
        :user_id => @users[i].id
      )
    end
    @note_texts = ["Note 0", "Note 1", "Note 2"].sort
  end

  after do
    @notes.each { |x| x.destroy } if @notes
    @users.each { |x| x.destroy }
  end

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
        @members = parsed_response_body['members']
      end

      use "return 200 Ok"

      test "body should have an empty list" do
        assert_equal [], @members
      end
    end
  end

  context "owner : get /" do
    before do
      get "/", :api_key => @users[0]._api_key
      @members = parsed_response_body['members']
    end

    use "return 200 Ok"

    test "body should have 1 note" do
      assert_equal 1, @members.length
    end

    test "body should have correct note text" do
      actual = @members.map { |e| e["text"] }
      assert_equal ["Note 0"], actual.sort
    end

    test "members should only have correct attributes" do
      correct = %w(text user_id id created_at updated_at)
      @members.each do |member|
        assert_properties(correct, member)
      end
    end
  end

  %w(admin).each do |role|
    context "#{role} : get /" do
      before do
        get "/", :api_key => api_key_for(role)
        @members = parsed_response_body['members']
      end

      use "return 200 Ok"

      test "body should have 3 notes" do
        assert_equal 3, @members.length
      end

      test "body should have correct note text" do
        actual = @members.map { |e| e["text"] }
        assert_equal @note_texts, actual.sort
      end

      test "notes should only have correct attributes" do
        correct = %w(text user_id id created_at updated_at)
        @members.each do |member|
          assert_properties(correct, member)
        end
      end
    end
  end

end
