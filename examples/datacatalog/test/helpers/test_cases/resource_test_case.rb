class ResourceTestCase < Test::Unit::TestCase

  include Rack::Test::Methods
  include RequestHelpers
  include ModelFactories

  before :all do
    @roles = {}
    %w(basic curator admin).map do |role|
      @roles[role] = create_user(
        :name => "#{role} User",
        :role => role
      )
    end
  end
  
  after :all do
    @roles.each_pair { |role, user| user.destroy }
  end
  
  def user_for(role)
    @roles[role]
  end
  
  def api_key_for(role)
    key = @roles[role].api_key
    raise "API key not found" unless key
    key
  end
  
end
