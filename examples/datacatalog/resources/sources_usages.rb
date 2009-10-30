module DataCatalog

  class SourcesUsages < Base
    include Resource

    parent Sources
    child_association :usages
    model Usage
    path "usages"

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
    property :description

    # == Callbacks
    
  end
  
  SourcesUsages.build

end
