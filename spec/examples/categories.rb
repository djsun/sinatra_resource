module DataCatalog

  class Categories
    include Resource

    model Category
    
    property :name
    property :parent_id
    property :sources
    property :source_ids do
      categorizations.map do |categorization|
        categorization.source.id
      end
    end

    permission_to_view :basic
    permission_to_modify :curator

    read_only :source_ids
    read_only :created_at
    read_only :updated_at

  end

end
