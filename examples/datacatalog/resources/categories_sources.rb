module DataCatalog

  class CategoriesSources < Base
    include Resource

    parent Categories
    child_association :sources
    model Source
    path "sources"

    relation :create do |parent, child|
      Categorization.create(
        :category_id => parent.id,
        :source_id   => child.id
      )
    end
    
    relation :delete do |parent, child|
      Categorization.find(:conditions => {
        :category_id => parent.id,
        :source_id   => child.id
      }).destroy
    end

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
