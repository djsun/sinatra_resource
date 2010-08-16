module DataCatalog

  class Sources < Base
    include Resource

    model Source

    # == Permissions

    roles Roles
    permission :list   => :basic
    permission :read   => :basic
    permission :create => :curator
    permission :update => :curator
    permission :delete => :curator

    # == Properties

    property :title
    property :url
    property :raw, :w => :admin, :hide_by_default => true

    property :categories do |source|
      source.categorizations.map do |categorization|
        {
          "id"   => categorization.category.id,
          "href" => "/categories/#{categorization.category.id}",
          "name" => categorization.category.name,
        }
      end
    end

    # == Callbacks
  end

  Sources.build

end
