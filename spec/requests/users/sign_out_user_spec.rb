require 'rails_helper'

describe 'DELETE /api/v1/users/sign_out', type: :request do
  # Create and confirm a user in the database
  let(:user) { create(:user) }
  let(:headers) { nil }
  let(:dummy_token) { nil }
  let(:dummy_client) { nil }

  context 'with signed-in user' do
    before do
      user.confirm
      user.reload
      headers = user.create_new_auth_token

      delete '/api/v1/users/sign_out', headers: {
        'access-token': headers['access-token'],
        'client': headers['client'],
        'uid': headers['uid']
      }
    end

    it 'returns success' do
      expect(response).to be_successful
    end

    it 'is signed out' do
      token = :headers['access-token']
      client = :headers['client']
      expect(user.reload.valid_token?(token, client)).to be_falsey
    end
  end

  context 'with signed-out user' do
    before do
      user.confirm
      user.reload
      dummy_token = 'dummy_token'
      dummy_client = 'dummy_client'

      delete '/api/v1/users/sign_out', headers: {
        'access-token': dummy_token,
        'client': dummy_client,
        'uid': user.uid
      }
    end

    it 'returns not found' do
      expect(response.status).to eq(404)
    end

    it 'returns errors upon failure' do
      json = JSON.parse(response.body)
      expect(json['errors']).to eq(['User was not found or was not logged in.'])
    end
  end
end
