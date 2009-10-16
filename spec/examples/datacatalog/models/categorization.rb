module DataCatalog

  class Categorization

    include MongoMapper::Document

    # == Attributes

    key :source_id,   String
    key :category_id, String
    timestamps!

    # == Indices

    # == Associations

    belongs_to :source
    belongs_to :category

  end

end
