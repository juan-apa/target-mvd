require 'rails_helper'

describe 'GET /api/v1/matches', type: :request do
  let!(:user_1)   { create :user }
  let!(:user_2) { create :user }
  let!(:target_1) { create :target, user: user_1 }
  let!(:targets_2) do
    create_list :target,
                3,
                radius: target_1.radius,
                latitude: target_1.latitude,
                longitude: target_1.longitude,
                topic_id: target_1.topic.id,
                user: user_2
  end

  context 'with signed-out user' do
    subject { get api_v1_matches_path, as: :json }

    it 'returns unauthorized' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns error message' do
      subject
      json = parsed_response
      expect(json).to include_json(errors: ['You need to sign in or sign up before continuing.'])
    end
  end

  context 'with signed-in user' do
    let(:headers) { auth_headers(user_2) }
    subject { get api_v1_matches_path, headers: headers, as: :json }

    it 'returns a success status' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns an array of matches' do
      subject
      matches_arr = targets_2.map do |target|
        {
          target_creator_id: target.id,
          target_compatible_id: target_1.id,
          user_creator_id: user_2.id,
          user_compatible_id: user_1.id
        }
      end
      expect(parsed_response).to include_json(matches: matches_arr)
    end
  end
end
