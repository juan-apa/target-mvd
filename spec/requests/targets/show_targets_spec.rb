require 'rails_helper'

describe 'GET /api/v1/targets/:id', type: :request do
  let!(:user)   { create :user }
  let!(:target) { create :target, user: user }
  let(:invalid_target_id) { 'invalid_target_id' }
  let(:headers) { auth_headers(user) }

  context 'with signed-out user' do
    before do
      get api_v1_targets_path(target.id), headers: {}, as: :json
    end

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns error message' do
      json = parsed_response
      expect(json).to include_json(errors: ['You need to sign in or sign up before continuing.'])
    end
  end

  context 'with signed-in user' do
    context 'with valid target_id' do
      before do
        get(api_v1_target_path(target.id), headers: headers, as: :json)
      end

      it 'returns success status' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the target' do
        json = parsed_response
        expected_json = {
          target: {
            id: target.id,
            topic_id: target.topic.id,
            title: target.title,
            radius: target.radius,
            latitude: Float(target.latitude).to_s,
            longitude: Float(target.longitude).to_s
          }
        }
        expect(json).to include_json(expected_json)
      end
    end

    context 'with invalid target_id' do
      before do
        get api_v1_target_path(invalid_target_id), headers: headers, as: :json
      end

      it 'returns not found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns not found error' do
        json = parsed_response
        expect(json).to include_json(error: 'Couldn\'t find the record')
      end
    end
  end
end
