module ModelFactories
  
  include DataCatalog
  
  def create_source(custom={})
    create_model!(Source, custom, {
      :title => "Healthcare Spending Data",
      :url   => "http://data.gov/details/23",
    })
  end
  
  def create_category(custom={})
    create_model!(Category, custom, {
      :name => "Sample Category",
    })
  end
  
  def create_categorization(custom={})
    create_model!(Categorization, custom, {
      :source_id   => "",
      :category_id => "",
    })
  end

  def create_user(custom={})
    create_model!(User, custom, {
      :name  => "Sample User",
      :email => "sample.user@inter.net",
      :role  => "basic",
    })
  end

  protected

  def create_model!(klass, custom, required)
    model = klass.create(required.merge(custom))
    unless model.valid?
      raise "Invalid #{klass}: #{model.errors.errors.inspect}"
    end
    model
  end

  def new_model!(klass, custom, required)
    model = klass.new(required.merge(custom))
    unless model.valid?
      raise "Invalid #{klass}: #{model.errors.errors.inspect}"
    end
    model
  end
  
end
