module DataCatalog

  class Categories
    include Resource

    model Category

    # == Permissions
    
    permission :read   => :basic
    permission :modify => :curator

    # == Properties
    
    property :name
    property :parent_id

    property :id,         :w => :nobody
    property :created_at, :w => :nobody
    property :updated_at, :w => :nobody

    property :sources, :read_only do
      sources.map do |source|
        {
          "id"    => source.id,
          "href"  => "/sources/#{source.id}",
          "title" => source.title,
          "url"   => source.url,
        }
      end
    end

  end

end
