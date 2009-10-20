module DataCatalog

  class Users < Base
    include Resource

    model User

    # == Permissions

    roles Roles
    permission :read   => :basic
    permission :modify => :owner

    # == Properties
  
    property :name,       :r => :basic
    property :email,      :r => :owner
    property :role,       :r => :owner, :w => :admin
    property :_api_key,   :r => :owner, :w => :admin

    # == Callbacks
  end
  
  Users.build

end
