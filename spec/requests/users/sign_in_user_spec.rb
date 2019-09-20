require 'rails_helper'

describe 'POST /api/v1/users/sign_in', type: :request do
  # Create a confirmed user in the database
  let(:user) { create(:user) }

  # Create a non confirmed user in the database
  let(:unconfirmed_user) { create(:user, unconfirmed: true) }

  context 'with unconfirmed email' do
    before do
      params = {
        user: {
          email: unconfirmed_user.email,
          password: unconfirmed_user.password
        }
      }
      post user_session_path, params: params, as: :json
    end

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns invalid email message' do
      json = parsed_response
      expected_response = {
        errors: [
          'A confirmation email was sent to your account at \'' +
            unconfirmed_user.email +
            '\'. You must follow the instructions in the' \
            ' email before your account can be activated'
        ]
      }
      expect(json).to include_json(expected_response)
    end
  end

  context 'with confirmed email' do
    context 'with correct params' do
      before do
        params = {
          user: {
            email: user.email,
            password: user.password
          }
        }

        post user_session_path, params: params, as: :json
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user' do
        json = parsed_response

        expect(json[:user]).to include_json(
          id: user.id,
          email: user.email,
          uid: user.email,
          provider: 'email',
          first_name: user.first_name,
          last_name: user.last_name,
          gender: user.gender
        )
      end

      it 'returns a valid client and access token' do
        token = response.header['access-token']
        client = response.header['client']

        expect(user.reload.valid_token?(token, client)).to be_truthy
      end
    end

    context 'with incorrect params' do
      before do
        params = {
          user: {
            email: user.email,
            password: user.password + 'wrong_password'
          }
        }
        post user_session_path, params: params, as: :json
      end

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'return errors upon failure' do
        json = parsed_response
        expected_response = {
          errors: ['Invalid login credentials. Please try again.']
        }
        expect(json).to include_json(expected_response)
      end
    end
  end
end
