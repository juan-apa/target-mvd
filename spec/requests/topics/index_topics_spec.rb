require 'rails_helper'

describe 'GET /api/v1/topics', type: :request do
  let(:topic) { create :topic }
  let(:user) { create :user }
  let(:invalid_topic_id) { topic.id + 1 }
  let(:headers) { auth_headers(user) }

  context 'with loged-out user' do
    before do
      get api_v1_topics_path, headers: {}, as: :json
    end

    it 'should return unauthorized status' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should should have an error message' do
      json = parsed_response
      expect(json).to include_json(errors: ['You need to sign in or sign up before continuing.'])
    end
  end

  context 'with loged-in user' do
    before do
      get api_v1_topics_path, headers: headers, as: :json
    end

    it 'should return success status' do
      expect(response).to have_http_status(:success)
    end

    it 'should return the topics array' do
      json = parsed_response
      expected_response = { topics: [] }
      expect(json).to include_json(expected_response)
    end
  end
end
