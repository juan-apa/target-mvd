require 'rails_helper'

describe 'POST api/v1/users/', type: :request do
  let!(:user)    { create :user }
  let!(:topic)   { create :topic }
  let!(:target)  { build :target, user: user, topic: topic }
  let!(:target_with_invalid_topic)  { build :target_with_invalid_topic, user: user }
  let!(:headers) { auth_headers(user) }

  context 'with signed-out user' do
    before do
      post api_v1_targets_path, params: user, headers: {}, as: :json
    end

    it 'returns an error code' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns an error message' do
      json = parsed_response
      expected_response = {
          errors: ['You need to sign in or sign up before continuing.']
      }
      expect(json).to include_json(expected_response)
    end
  end

  context 'with signed-in user' do
    context 'with correct params' do
      it 'changes the amount of targets by one' do
        expect {
          post api_v1_targets_path, params: target, headers: headers, as: :json
        }.to change(Target, :count).by(1)
      end

      it 'returns a success code' do
        post api_v1_targets_path, params: target, headers: headers, as: :json
        expect(response).to have_http_status(:success)
      end

      it 'returns the target' do
        post api_v1_targets_path, params: target, headers: headers, as: :json
        json = parsed_response
        expected_response = {
          target: {
            id: Target.last.id,
            topic_id: target.topic.id,
            title: target.title,
            radius: target.radius,
            latitude: Float(target.latitude).to_s,
            longitude: Float(target.longitude).to_s
          }
        }
        expect(json).to include_json(expected_response)
      end
    end

    context 'with non existant topic' do
      before do
        post api_v1_targets_path, params: target_with_invalid_topic, headers: headers, as: :json
      end

      it 'returns error status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error message' do
        json = parsed_response
        expected_response = {
          errors: {
            topic: [ 'must exist' ]
          }
        }
        expect(json).to include_json(expected_response)
      end
    end
  end
end
