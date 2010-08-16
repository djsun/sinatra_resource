class ResourceTestCase < Test::Unit::TestCase

  include Rack::Test::Methods
  include RequestHelpers
  include ModelFactories

  before :all do
    @users_by_role = {}
    %w(basic curator admin).map do |role|
      @users_by_role[role] = create_user(
        :name  => "#{role} User",
        :email => "#{role}-user@inter.net",
        :role  => role
      )
    end
  end

  after :all do
    @users_by_role.each_pair { |role, user| user.destroy }
  end

  def user_for(role)
    @users_by_role[role]
  end

  def api_key_for(role)
    key = @users_by_role[role]._api_key
    raise "API key not found" unless key
    key
  end

  def valid_params_for(role)
    @valid_params.merge(:api_key => api_key_for(role))
  end

end
