require 'rubygems'

# Note: mongo_mapper-0.7.0 requires 0.18.3 specifically.
# However, there is a more recent mongo and mongo_ext (0.19).
# Unless we specifically require mongo-0.18.3 and mongo_ext-0.18.3,
# there will be a "Notice: C extension not loaded" warning.
gem 'mongo', "= 0.18.3", '< 1.0'
gem 'mongo_ext', "= 0.18.3", '< 1.0'
require 'mongo'

gem 'mongo_mapper', '>= 0.7', '< 0.8'
require 'mongo_mapper'

module Config
  
  def self.setup
    setup_mongomapper
    # More application setup can go here...
  end
  
  def self.setup_mongomapper
    MongoMapper.connection = new_mongo_connection
    MongoMapper.database = environment_config['mongo_database']
  end
  
  def self.new_mongo_connection
    Mongo::Connection.new(environment_config["mongo_hostname"])
  end

  def self.drop_database
    database_name = environment_config["mongo_database"]
    new_mongo_connection.drop_database(database_name)
    database_name
  end

  def self.environment_config
    env_config = config[environment]
    unless env_config
      raise "Environment config not found for #{environment.inspect}"
    end
    env_config
  end

  def self.environment
    if @environment
      @environment
    else
      @environment = if Object.const_defined?("Sinatra")
        Sinatra::Base.environment.to_s
      else
        ENV['RACK_ENV'] || 'development'
      end
    end
  end
  
  def self.environment=(env)
    @environment = env
  end

  def self.environments
    config.keys
  end
  
  def self.config
    if @config
      @config
    else
      file = File.join(File.dirname(__FILE__), "config.yml")
      @config = YAML.load_file(file)
    end
  end

end
