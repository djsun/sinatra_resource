module DataCatalog

  class Category

    include MongoMapper::Document

    # == Attributes

    key :name, String
    key :log,  String
    timestamps!

    # == Indices

    # == Associations

    many :categorizations,
      :class_name  => 'DataCatalog::Categorization',
      :foreign_key => :category_id

    def sources
      categorizations.map(&:source)
    end

    # == Validations

    validates_presence_of :name

  end

end
