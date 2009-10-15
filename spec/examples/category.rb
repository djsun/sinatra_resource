class Category

  include MongoMapper::Document

  key :name, String
  key :parent_id, String
  timestamps!

  many :categorizations

  def sources
    categorizations.map(&:source)
  end

  validates_presence_of :name

end
