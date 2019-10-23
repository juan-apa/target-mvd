class FacebookService
  # extend self

  def initialize(access_token)
    @graph = Koala::Facebook::API.new(access_token)
  end

  def get_user_data()
    @data = @graph.get_object('me?fields=email,first_name,last_name,gender').with_indifferent_access
    @data.merge(gender: 'male') unless @data[:gender]
  end
end
