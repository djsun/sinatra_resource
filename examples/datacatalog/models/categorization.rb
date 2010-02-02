module DataCatalog

  class Categorization

    include MongoMapper::Document

    # == Attributes

    key :source_id,   Mongo::ObjectID
    key :category_id, Mongo::ObjectID
    timestamps!

    # == Indices

    # == Associations

    belongs_to :source,   :class_name => 'DataCatalog::Source'
    belongs_to :category, :class_name => 'DataCatalog::Category'

    # == Validations
    
    validate :validate_associations

    def validate_associations
      errors.add(:source_id, "must be valid") if source.nil?
      errors.add(:category_id, "must be valid") if category.nil?
    end

  end

end
