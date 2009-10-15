require File.expand_path(File.dirname(__FILE__) + '/users_keys')

module DataCatalog

  class Users
    include Resource

    model User

    nested_resource UsersKeys, :association => :api_keys

    # == Permissions

    permission :read   => :owner
    permission :modify => :owner

    # == Properties
  
    property :name,       :r => :basic
    property :email
    property :curator,    :w => :admin
    property :admin,      :w => :admin

    property :id,         :r => :basic, :w => :nobody
    property :created_at, :w => :nobody
    property :updated_at, :w => :nobody
    property :api_keys,   :w => :nobody

    property :application_api_keys do
      objects = api_keys.select { |k| k.key_type == "application" }
      objects.map { |k| k.api_key }
    end

    property :primary_api_key, :read_only do
      keys = api_keys.select { |k| k.key_type == "primary" }
      case keys.length
      when 0 then nil
      when 1 then keys[0][:api_key]
      else raise InconsistentState, "More than one primary API key found"
      end
    end

    property :valet_api_keys, :read_only do
      objects = api_keys.select { |k| k.key_type == "valet" }
      objects.map { |k| k.api_key }
    end

    # == Callbacks
    
    callback :after_create do
      @document.add_api_key!({ :key_type => "primary" })
    end
    
  end

end
