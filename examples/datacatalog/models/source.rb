module DataCatalog

  class Source

    include MongoMapper::Document

    # == Attributes

    key :title,       String
    key :description, String
    key :url,         String
    key :raw,         Hash
    key :_keywords,   Array
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

    # == Callbacks

    before_save :update_keywords
    def update_keywords
      self._keywords = DataCatalog::Search.process([title, description])
    end

  end

end
