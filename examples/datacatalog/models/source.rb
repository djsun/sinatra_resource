module DataCatalog
  
  class Source

    include MongoMapper::Document

    # == Attributes

    key :title, String
    key :url,   String
    key :raw,   Hash
    timestamps!

    # == Indices

    ensure_index :url

    # == Associations

    many :categorizations

    def categories
      categorizations.map(&:category)
    end

    # == Validations

    validates_presence_of :title
    validates_presence_of :url

  end

end
