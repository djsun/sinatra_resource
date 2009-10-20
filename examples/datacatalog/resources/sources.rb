module DataCatalog

  class Sources < Base
    include Resource

    model Source

    # == Permissions

    roles Roles
    permission :read   => :basic
    permission :modify => :curator
    
    # == Properties

    property :title
    property :url
    property :raw, :w => :admin
    
    property :categories do |source|
      source.categorizations.map do |categorization|
        {
          "id"   => categorization.category.id,
          "href" => "/categories/#{categorization.category.id}",
          "name" => categorization.category.name,
        }
      end
    end

    # == Callbacks
  end
  
  Sources.build

end
