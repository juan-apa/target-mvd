require 'rails_helper'

describe 'POST api/v1/users/', type: :request do
  before do
    allow_any_instance_of(FacebookService).to receive(:user_data).and_return(service_response)
  end

  let!(:service_response) do
    {
      first_name: 'first_name',
      last_name: 'last_name',
      email: 'example@example.com',
      gender: 'male',
      id: '123456789'
    }
  end
  subject { post api_v1_users_facebook_sign_in_path, params: params, headers: headers }
  let!(:params) { { access_token: 'access_token' } }
  let!(:headers) { {} }

  context 'with non existant user' do
    it 'creates the user' do
      expect { subject }.to change { User.count }.by(1)
    end

    it 'returns the user data' do
      expected_response = {
        user: {
          first_name: 'first_name',
          last_name: 'last_name',
          email: 'example@example.com',
          gender: 'male',
          provider: 'facebook',
          uid: '123456789'
        }
      }
      subject
      expect(parsed_response).to include_json(expected_response)
    end

    it 'returns a success status' do
      subject
      expect(response).to have_http_status(:success)
    end
  end

  context 'with existent user' do
    let!(:user) do
      create :user,
             email: service_response[:email],
             first_name: service_response[:first_name],
             last_name: service_response[:last_name],
             gender: service_response[:gender],
             uid: service_response[:id],
             provider: 'facebook'
    end

    it 'doesn\'t create a new user' do
      expect { subject }.not_to change { User.count }
    end

    it 'returns a success status' do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
