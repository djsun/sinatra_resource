class Category

  include MongoMapper::Document

  # == Attributes

  key :name, String
  key :parent_id, String
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
