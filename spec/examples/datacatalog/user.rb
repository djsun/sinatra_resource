require 'digest/sha1'

module DataCatalog
  
  class User
  
    include MongoMapper::Document
    include Renderable

    class InconsistentState < RuntimeError; end

    # == Attributes

    key :name,  String
    key :email, String
    key :role,  String
    timestamps!

    # == Indices

    ensure_index :email
    ensure_index 'api_keys.api_key' # not tested

    # == Associations

    many :api_keys
    many :ratings

    # == Validations

    # == Class Methods

    def self.find_by_api_key(api_key)
      find(:first, :conditions => { 'api_keys.api_key' => api_key })
      # TODO: find :all and raise exception if more than 1 result
    end

    # == Various Instance Methods

    def generate_api_key
      salt = Config.environment_config["api_key_salt"]
      s = "#{Time.now.to_f}#{salt}#{rand(100_000_000)}#{name}#{email}"
      Digest::SHA1.hexdigest(s)
    end

    # Example usage:
    #
    #   user = User.new
    #   user.add_api_key!({ :key_type => "primary" })
    #   user.add_api_key!({ :key_type => "application" })
    #   user.add_api_key!({ :key_type => "valet" })
    #   user.save
    #
    def add_api_key!(params = {})
      unless params[:api_key]
        params.merge!({ :api_key => generate_api_key })
      end
      key = ApiKey.new(params)
      self.api_keys << key
      self.save!
    end
  
  end

end
