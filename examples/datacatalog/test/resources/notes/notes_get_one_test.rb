require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class NotesGetOneResourceTest < ResourceTestCase

  include DataCatalog

  def app; Notes end
  
  before do
    @user = create_user
    @note = create_note(
      :user_id => @user.id
    )
  end

  after do
    @note.destroy
    @user.destroy
  end

  context "get /:id" do
    context "anonymous" do
      before do
        get "/#{@note.id}"
      end
    
      use "return 401 because the API key is missing"
    end

    context "incorrect API key" do
      before do
        get "/#{@note.id}", :api_key => BAD_API_KEY
      end
  
      use "return 401 because the API key is invalid"
    end
  end

  %w(basic curator).each do |role|
    context "#{role} : get /:fake_id" do
      before do
        get "/#{FAKE_ID}", :api_key => api_key_for(role)
      end
    
      use "return 401 because the API key is unauthorized"
    end
  
    context "#{role} : get /:id" do
      before do
        get "/#{@note.id}", :api_key => api_key_for(role)
      end
      
      use "return 401 because the API key is unauthorized"
    end
  end

  context "owner : get /:id" do
    before do
      get "/#{@note.id}", :api_key => @user._api_key
    end

    use "return 200 Ok"
    doc_properties %w(text user_id id created_at updated_at)
  end

  %w(admin).each do |role|
    context "#{role} : get /:fake_id" do
      before do
        get "/#{FAKE_ID}", :api_key => api_key_for(role)
      end
    
      use "return 404 Not Found with empty response body"
    end

    context "#{role} : get /:id" do
      before do
        get "/#{@note.id}", :api_key => api_key_for(role)
      end

      use "return 200 Ok"
      doc_properties %w(text user_id id created_at updated_at)
    end
  end

end
