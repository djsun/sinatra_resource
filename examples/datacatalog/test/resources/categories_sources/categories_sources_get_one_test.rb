require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class CategoriesSourcesGetOneResourceTest < ResourceTestCase

  include DataCatalog

  def app; Categories end

  before do
    @category = create_category
    @source = create_source
    @categorization = create_categorization(
      :source_id   => @source.id,
      :category_id => @category.id
    )
    @other_category = create_category
    @other_source = create_source
    @other_categorization = create_categorization(
      :source_id   => @other_source.id,
      :category_id => @other_category.id
    )
  end

  after do
    @other_categorization.destroy
    @other_source.destroy
    @other_category.destroy
    @categorization.destroy
    @source.destroy
    @category.destroy
  end

  context "get /:id/sources/:id" do
    context "anonymous" do
      before do
        get "/#{@category.id}/sources/#{@source.id}"
      end

      use "return 401 because the API key is missing"
    end

    context "incorrect API key" do
      before do
        get "/#{@category.id}/sources/#{@source.id}", :api_key => BAD_API_KEY
      end

      use "return 401 because the API key is invalid"
    end
  end

  %w(basic curator admin).each do |role|
    context "#{role} : get /:fake_id/sources/:fake_id" do
      before do
        get "/#{FAKE_ID}/sources/#{FAKE_ID}", :api_key => api_key_for(role)
      end

      use "return 404 Not Found with empty response body"
    end

    context "#{role} : get /:fake_id/sources/:id" do
      before do
        get "/#{FAKE_ID}/sources/#{@source.id}", :api_key => api_key_for(role)
      end

      use "return 404 Not Found with empty response body"
    end

    context "#{role} : get /:id/sources/:fake_id" do
      before do
        get "/#{@category.id}/sources/#{FAKE_ID}", :api_key => api_key_for(role)
      end

      use "return 404 Not Found with empty response body"
    end

    context "#{role} : get /:id/sources/:not_related_id" do
      before do
        get "/#{@category.id}/sources/#{@other_source.id}",
          :api_key => api_key_for(role)
      end

      use "return 404 Not Found with empty response body"
    end

    context "#{role} : get /:id/sources/:id" do
      before do
        get "/#{@category.id}/sources/#{@source.id}", :api_key => api_key_for(role)
      end

      use "return 200 Ok"
      doc_properties %w(title url raw id created_at updated_at)
    end
  end

end
