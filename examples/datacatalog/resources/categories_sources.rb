module DataCatalog

  class CategoriesSources < Base
    include Resource

    parent Categories
    path "sources"
    model Source

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
