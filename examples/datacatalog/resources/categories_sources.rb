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
    permission :list   => :basic
    permission :read   => :basic
    permission :create => :curator
    permission :update => :curator
    permission :delete => :curator
    
    # == Properties

    property :title
    property :url
    property :raw, :w => :admin

    # == Callbacks
    
  end
  
  CategoriesSources.build

end
