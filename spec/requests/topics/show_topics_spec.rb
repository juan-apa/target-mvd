require 'rails_helper'

describe 'GET /api/v1/topics/:id', type: :request do
  let(:topic) { create :topic }
  let(:user) { create :user }
  let(:invalid_topic_id) { 'invalid_topic_id' }
  let(:headers) { auth_headers(user) }

  context 'with signed-out user' do
    before do
      get api_v1_topic_path(topic.id), headers: {}, as: :json
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
    context 'with valid topic_id' do
      before do
        get(api_v1_topic_path(topic.id), headers: headers, as: :json)
      end

      it 'returns success status' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the topic' do
        json = parsed_response
        expected_json = {
          topic: {
            id: topic.id,
            title: topic.title
          }
        }
        expect(json).to include_json(expected_json)
      end
    end

    context 'with invalid topic_id' do
      before do
        get api_v1_topic_path(invalid_topic_id), headers: headers, as: :json
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
