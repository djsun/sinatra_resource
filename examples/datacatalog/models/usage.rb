module DataCatalog

  class Usage
  
    include MongoMapper::EmbeddedDocument

    # == Attributes

    key :title,       String
    key :url,         String
    key :description, String

    # == Indices

    # == Associations

    # == Validations

    # TODO: As of 2009-10-29, MongoMapper does not support validations on
    # EmbeddedDocuments.
    # 
    # validates_presence_of :title
    # validates_presence_of :url
  
    # == Class Methods

    # == Various Instance Methods

  end

end
