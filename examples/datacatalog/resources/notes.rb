module DataCatalog

  class Notes < Base
    include Resource

    model Note

    # == Permissions

    roles Roles
    permission :list   => :basic
    permission :read   => :owner
    permission :create => :basic
    permission :update => :owner
    permission :delete => :owner

    # == Properties

    property :text
    property :user_id

    # == Callbacks

  end
  
  Notes.build

end
