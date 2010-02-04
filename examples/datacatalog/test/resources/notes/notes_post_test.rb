require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class NotesPostResourceTest < ResourceTestCase
  
  include DataCatalog

  def app; Notes end
  
  before do
    @note_count = Note.all.length
    @user = create_user
    @valid_params = {
      :text    => "New Note",
      :user_id => @user.id
    }
  end
  
  after do
    @user.destroy
  end

  context "post /" do
    context "anonymous" do
      before do
        post "/", @valid_params
      end
    
      use "return 401 because the API key is missing"
      use "no change in note count"
    end

    context "incorrect API key" do
      before do
        post "/", @valid_params.merge(:api_key => BAD_API_KEY)
      end
  
      use "return 401 because the API key is invalid"
      use "no change in note count"
    end
  end

  %w(basic curator admin).each do |role|
    [:text, :user_id].each do |missing|
      context "#{role} : post / but missing #{missing}" do
        before do
          post "/", valid_params_for(role).delete_if { |k, v| k == missing }
        end
  
        use "return 400 Bad Request"
        use "no change in note count"
        missing_param missing
      end
    end
  
    [:id, :created_at, :updated_at, :junk].each do |invalid|
      context "#{role} : post / but with #{invalid}" do
        before do
          post "/", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 400 Bad Request"
        use "no change in note count"
        invalid_param invalid
      end
    end
  
    context "#{role} : post / with valid params" do
      before do
        post "/", valid_params_for(role)
      end
  
      after do
        Note.find_by_id(parsed_response_body["id"]).destroy
      end
  
      use "return 201 Created"
      location_header "notes"
      use "one new note"
      doc_properties %w(text user_id id created_at updated_at)
  
      test "should set all fields in database" do
        note = Note.find_by_id(parsed_response_body["id"])
        raise "Cannot find note" unless note
        @valid_params.each_pair do |key, value|
          assert_equal value, note[key]
        end
      end
    end
  end

end
