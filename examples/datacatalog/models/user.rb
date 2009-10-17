require 'digest/sha1'

module DataCatalog
  
  class User
  
    include MongoMapper::Document

    # == Attributes

    key :name,    String
    key :email,   String
    key :role,    String
    key :api_key, String
    timestamps!

    # == Indices

    ensure_index :email

  end

end
