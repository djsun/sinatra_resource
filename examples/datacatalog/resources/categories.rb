module DataCatalog

  class Categories < Base
    include Resource

    model Category

    # == Permissions

    roles Roles
    permission :list   => :basic
    permission :read   => :basic
    permission :create => :curator
    permission :update => :curator
    permission :delete => :curator

    # == Properties
    
    property :name
    property :log

    property :sources do |category|
      category.sources.map do |source|
        {
          "id"    => source.id,
          "href"  => "/sources/#{source.id}",
          "title" => source.title,
          "url"   => source.url,
        }
      end
    end
    
    # == Callbacks
    
    callback :before_create do |action|
      action.params["log"] = "before_create"
    end
    
    callback :after_create do |action, category|
      category.log += " after_create"
    end

    callback :before_update do |action, category|
      action.params["log"] = "before_update"
    end
    
    callback :after_update do |action, category|
      category.log += " after_update"
    end

    callback :before_destroy do |action, category|
      action.headers 'X-Test-Callbacks' => 'before_destroy'
    end
    
    callback :after_destroy do |action, category|
      x = action.response['X-Test-Callbacks']
      action.headers 'X-Test-Callbacks' => "#{x} after_destroy"
    end

  end
  
  Categories.build

end
