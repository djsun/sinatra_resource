module DataCatalog

  class Note

    include MongoMapper::Document

    # == Attributes

    key :text,      String
    key :user_id,   ObjectId
    timestamps!
  
    # == Indices

    # == Associations

    belongs_to :user, :class_name => 'DataCatalog::User'

    # == Validations

    validates_presence_of :text
    validates_presence_of :user_id

    validate :general_validation

    def general_validation
      if user.nil?
        errors.add(:user_id, "must be valid")
      end
    end

    # == Class Methods

    # == Various Instance Methods

  end

end
