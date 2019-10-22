module FacebookService
  extend self

  def get_user_data(access_token)
    graph = Koala::Facebook::API.new access_token
    graph.get_object('me?fields=email,first_name,last_name,gender').with_indifferent_access
    graph.merge(gender: 'male') unless graph[:gender]
  end
end
