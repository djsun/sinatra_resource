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
    
    # == Callbacks
    
    def before_create
      self.api_key = generate_api_key
    end

    def generate_api_key
      salt = Config.environment_config["api_key_salt"]
      s = "#{Time.now.to_f}#{salt}#{rand(100_000_000)}#{name}#{email}"
      Digest::SHA1.hexdigest(s)
    end

  end

end
