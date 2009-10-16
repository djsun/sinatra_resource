require File.expand_path(File.dirname(__FILE__) + '/users_keys')

module DataCatalog

  class Users
    include Resource

    model User

    # == Permissions

    permission :read   => :owner
    permission :modify => :owner

    # == Properties
  
    property :name,       :r => :basic
    property :email
    property :role,       :w => :admin

    property :id,         :r => :basic, :w => :nobody
    property :created_at, :w => :nobody
    property :updated_at, :w => :nobody

    # == Callbacks
    
  end

end
