module DataCatalog

  class Sources
    include Resource

    model Source

    # == Permissions

    permission :read   => :basic
    permission :modify => :curator
    
    # == Properties

    property :title
    property :url
    property :raw,              :w => :admin

    property :id,               :w => :nobody
    property :created_at,       :w => :nobody
    property :updated_at,       :w => :nobody
    
    property :categories do
      categorizations.map do |categorization|
        {
          "id"   => categorization.category.id,
          "href" => "/categories/#{categorization.category.id}",
          "name" => categorization.category.name,
        }
      end
    end

    # == Callbacks

  end

end
