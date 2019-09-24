require 'rails_helper'

describe 'DELETE /api/v1/users/sign_out', type: :request do
  # Create a confirmed user in the database
  subject { create(:user) }
  let(:headers) { nil }
  let(:dummy_token) { 'dummy_token' }
  let(:dummy_client) { 'dummy_client' }

  context 'with signed-in user' do
    before do
      headers = subject.create_new_auth_token
      delete destroy_user_session_path, headers: {
        'access-token': headers['access-token'],
        'client': headers['client'],
        'uid': headers['uid']
      }
    end

    it 'returns success' do
      expect(response).to have_http_status(:success)
    end

    it 'is signed out' do
      token = :headers['access-token']
      client = :headers['client']
      expect(subject.reload.valid_token?(token, client)).to be_falsey
    end
  end

  context 'with signed-out user' do
    before do
      delete destroy_user_session_path, headers: {
        'access-token': dummy_token,
        'client': dummy_client,
        'uid': subject.uid
      }
    end

    it 'returns not found' do
      expect(response).to have_http_status(:not_found)
    end

    it 'returns errors upon failure' do
      json = parsed_response
      expect(json['errors']).to include_json(['User was not found or was not logged in.'])
    end
  end
end
