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

    many :usages,
      :class_name  => 'DataCatalog::Usage',
      :foreign_key => :source_id

    many :categorizations,
      :class_name  => 'DataCatalog::Categorization',
      :foreign_key => :source_id

    def categories
      categorizations.map(&:category)
    end

    # == Validations

    validates_presence_of :title
    validates_presence_of :url

  end

end
