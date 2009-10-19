require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesPutResourceTest < ResourceTestCase

  def app; DataCatalog::Sources end

  before do
    @source = create_source
    @source_copy = @source.dup
    @valid_params = {
      :title   => "Changed Source",
      :url     => "http://updated.com/details/7"
    }
  end

  after do
    @source.destroy
  end
  
  context "put /" do
    context "anonymous" do
      before do
        put "/#{@source.id}", @valid_params
      end
    
      use "return 401 because the API key is missing"
      unchanged :source
    end

    context "incorrect API key" do
      before do
        put "/#{@source.id}", @valid_params.merge(:api_key => BAD_API_KEY)
      end
  
      use "return 401 because the API key is invalid"
      unchanged :source
    end
  end

  %w(basic).each do |role|
    [:title, :url].each do |missing|
      context "#{role} : put / without #{missing}" do
        before do
          put "/#{@source.id}", valid_params_for(role).delete_if { |k, v| k == missing }
        end
  
        use "return 401 Unauthorized"
        unchanged :source
      end
    end

    [:id, :created_at, :updated_at, :categories].each do |invalid|
      context "#{role} : put / but with #{invalid}" do
        before do
          put "/#{@source.id}", valid_params_for(role).merge(invalid => 9)
        end
  
        use "return 401 Unauthorized"
        unchanged :source
      end
    end

    context "#{role} : put / with valid params" do
      before do
        put "/#{@source.id}", valid_params_for(role)
      end
      
      use "return 401 Unauthorized"
      unchanged :source
    end
  end

  # %w(curator).each do |role|
  #   [:title, :url].each do |missing|
  #     context "#{role} : put / without #{missing}" do
  #       before do
  #         put "/#{@source.id}", valid_params_for(role).delete_if { |k, v| k == missing }
  #       end
  #     
  #       use "return 400 Bad Request"
  #       missing_param missing
  #     end
  #   end
  # 
  #   [:raw, :created_at, :updated_at, :categories].each do |invalid|
  #     context "#{role} : put / but with #{invalid}" do
  #       before do
  #         put "/#{@source.id}", valid_params_for(role).merge(invalid => 9)
  #       end
  # 
  #       use "return 400 Bad Request"
  #       invalid_param invalid.to_s
  #     end
  #   end
  # 
  #   [:title, :url].each do |missing|
  #     context "#{role} : put / without #{missing}" do
  #       before do
  #         put "/#{@source.id}", valid_params_for(role).delete_if { |k, v| k == missing }
  #       end
  #     
  #       use "return 200 Ok"
  #       doc_properties %w(title url raw id created_at updated_at categories)
  #     end
  #   end
  # end
  
  # %w(curator).each do |role|
  #   context "#{role} : put / with valid params" do
  #     before do
  #       put "/#{@source.id}", valid_params_for(role)
  #     end
  # 
  #     use "return 200 Ok"
  #     doc_properties %w(title url raw id created_at updated_at categories)
  #   end
  # end
  # 
  # %w(admin).each do |role|
  #   [:id, :created_at, :updated_at, :categories].each do |invalid|
  #     context "#{role} : put / but with #{invalid}" do
  #       before do
  #         put "/#{@source.id}", valid_params_for(role).merge(
  #           :raw    => 3,
  #           invalid => 9
  #         )
  #       end
  # 
  #       use "return 400 Bad Request"
  #       invalid_param invalid.to_s
  #     end
  #   end
  # 
  #   context "#{role} : put / with valid params" do
  #     before do
  #       put "/#{@source.id}", valid_params_for(role).merge(:raw => 3)
  #     end
  # 
  #     use "return 200 Ok"
  #     doc_properties %w(title url raw id created_at updated_at categories)
  #   end
  # end

end
