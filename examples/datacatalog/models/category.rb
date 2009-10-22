module DataCatalog

  class Category

    include MongoMapper::Document

    # == Attributes

    key :name, String
    key :log,  String
    timestamps!

    # == Indices

    # == Associations

    many :categorizations

    def sources
      categorizations.map(&:source)
    end

    # == Validations

    validates_presence_of :name

  end

end
