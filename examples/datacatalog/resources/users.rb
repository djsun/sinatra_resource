module DataCatalog

  class Users < Base
    include Resource

    model User

    # == Permissions

    roles Roles
    permission :list   => :basic
    permission :read   => :basic
    permission :create => :admin
    permission :update => :owner
    permission :delete => :owner

    # == Properties
  
    property :name,       :r => :basic
    property :email,      :r => :owner
    property :role,       :r => :owner, :w => :admin
    property :_api_key,   :r => :owner, :w => :admin
    
    property :token, :r => :owner do |user|
      user.token
    end

    # == Callbacks
  end
  
  Users.build

end
