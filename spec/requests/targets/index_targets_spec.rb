require 'rails_helper'

describe 'GET /api/v1/targets', type: :request do
  let!(:user)   { create :user }
  let!(:topic)  { create :topic }

  let!(:targets) { create_list(:target, 3, user: user) }

  let(:headers) { auth_headers(user) }

  context 'with loged-out user' do
    before do
      get api_v1_targets_path, headers: {}, as: :json
    end

    it 'returns unauthorized status' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'have an error message' do
      json = parsed_response
      expect(json).to include_json(errors: ['You need to sign in or sign up before continuing.'])
    end
  end

  context 'with loged-in user' do
    before do
      get api_v1_targets_path, headers: headers, as: :json
    end

    it 'returns success status' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the targets array' do
      json = parsed_response
      targets_arr = targets.map do |target|
        {
          id: target.id,
          title: target.title,
          # I don't know how I arrived at this, but it works
          latitude: Float(target.latitude).to_s,
          longitude: Float(target.longitude).to_s,
          topic_id: target.topic.id
        }
      end
      expected_response = { targets: targets_arr }
      expect(json).to include_json(expected_response)
    end
  end
end
