require 'rails_helper'

describe 'PUT api/v1/users/passwords/', type: :request do
  let(:user) { create :user }
  let(:password_token) { user.send(:set_reset_password_token) }
  let(:headers) do
    params = {
      reset_password_token: password_token,
      redirect_url: ENV['PASSWORD_RESET_URL']
    }
    get edit_user_password_path, params: params, headers: auth_headers(user)
    edit_response_params = Addressable::URI.parse(response.header['Location']).query_values
    {
      'access-token' => edit_response_params['token'],
      'uid' => edit_response_params['uid'],
      'client' => edit_response_params['client_id']
    }
  end
  subject(:update_password) { put user_password_path, params: params, headers: headers }

  context 'with valid params' do
    let(:params) do
      {
        password: 'P4$$w0rd',
        password_confirmation: 'P4$$w0rd'
      }
    end

    it 'returns a success status code' do
      update_password
      expect(response).to have_http_status(:success)
    end

    it 'changes the password' do
      expect { update_password }.to change { user.updated_at }
    end
  end

  context 'with invalid password length' do
    let(:params) do
      {
        password: '1',
        password_confirmation: '1'
      }
    end

    it 'returns an error status' do
      update_password
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns an error message' do
      update_password
      expected_response = {
        errors: {
          password: ['is too short (minimum is 6 characters)']
        }
      }
      expect(parsed_response).to include_json(expected_response)
    end

    it 'doesn\'t change the password' do
      expect { update_password }.not_to change { user.password }
    end
  end

  context 'with non-matching passwords' do
    let(:params) do
      {
        password: 'P4$$w0rd',
        password_confirmation: 'nonmatchingpassword'
      }
    end

    it 'returns an error status' do
      update_password
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns an error message' do
      update_password
      expected_response = {
        errors: {
          password_confirmation: ['doesn\'t match Password']
        }
      }
      expect(parsed_response).to include_json(expected_response)
    end

    it 'doesn\'t change the password' do
      expect { update_password }.not_to change { user.password }
    end
  end
end
