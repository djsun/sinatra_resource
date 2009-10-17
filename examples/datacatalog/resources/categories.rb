module DataCatalog

  class Categories < Base
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

    property :sources do
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
  
  Categories.build

end
