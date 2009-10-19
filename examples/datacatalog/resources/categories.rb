module DataCatalog

  class Categories < Base
    include SinatraResource::Resource

    model Category

    # == Permissions

    roles Roles
    permission :read   => :basic
    permission :modify => :curator

    # == Properties
    
    property :name

    property :sources do
      sources.map do |source|
        {
          "id"    => source.id,
          "href"  => "/sources/#{source.id}",
          "title" => source.title,
          "url"   => source.url,
        }
      end
    end
  end
  
  Categories.build

end
