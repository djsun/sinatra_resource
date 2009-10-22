module DataCatalog

  class CategoriesSources < Base
    include Resource

    parent Categories
    association :sources
    model Source
    path "sources"

    # == Permissions

    roles Roles
    permission :read   => :basic
    permission :modify => :curator
    
    # == Properties

    property :title
    property :url
    property :raw, :w => :admin

    # == Callbacks
  end
  
  CategoriesSources.build

end
