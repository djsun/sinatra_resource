require File.expand_path(File.dirname(__FILE__) + '/../helpers/model_test_helper')

class NoteTest < ModelTestCase
  
  include DataCatalog

  context "Note" do
    before do
      @user = create_user
      @required = {
        :text    => "Example Note",
        :user_id => @user.id
      }
    end
    
    after do
      @user.destroy
    end
  
    context "correct params" do
      before do
        @note = Note.new(@required)
      end
      
      test "should be valid" do
        assert_equal true, @note.valid?
      end
    end

    [:text, :user_id].each do |missing|
      context "missing #{missing}" do
        before do
          @note = Note.new(@required.delete_if { |k, v| k == missing })
        end
        
        missing_key(:note, missing)
      end
    end

  end
  
end
