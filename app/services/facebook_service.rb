class FacebookService
  def initialize(access_token)
    @graph = Koala::Facebook::API.new(access_token)
  end

  def user_data
    return profile if profile[:gender]

    profile.merge(gender: 'male')
  end

  private

  def profile
    @graph.get_object('me?fields=email,first_name,last_name,gender').with_indifferent_access
  end
end
