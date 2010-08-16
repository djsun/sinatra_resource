require 'digest/sha1'

module DataCatalog

  class User

    include MongoMapper::Document

    # == Attributes

    key :name,     String
    key :email,    String
    key :role,     String
    key :_api_key, String
    timestamps!

    # == Indices

    ensure_index :email

    # == Validations

    validates_presence_of :name
    validates_presence_of :role
    validate :validate_role

    VALID_ROLES = %w(basic curator admin)

    def validate_role
      unless VALID_ROLES.include?(role)
        errors.add(:role, "must be in #{VALID_ROLES.inspect}")
      end
    end

    # == Callbacks

    before_create :assign_api_key
    def assign_api_key
      unless _api_key
        self._api_key = generate_api_key
      end
    end

    def generate_api_key
      salt = Config.environment_config["api_key_salt"]
      s = "#{Time.now.to_f}#{salt}#{rand(100_000_000)}#{name}#{email}"
      Digest::SHA1.hexdigest(s)
    end

    # == Various Instance Methods

    def token
      Digest::SHA1.hexdigest("#{id}/#{email}/123456789")
    end

  end

end
