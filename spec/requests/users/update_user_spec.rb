require 'rails_helper'

describe 'PATCH /api/v1/users/', type: :request do
  let!(:user) { create :user }
  subject(:update_registration) do
    patch user_registration_path, params: { user: user_param }, headers: header_param, as: :json
  end

  context 'with logged-out user' do
    let(:header_param) { {} }
    let(:user_param) { build :user }

    it 'returns an error code' do
      update_registration
      expect(response).to have_http_status(:not_found)
    end

    it 'returns an error message' do
      update_registration
      json = parsed_response
      expected_response = {
        error: 'User not found.'
      }
      expect(json).to include_json(expected_response)
    end
  end

  context 'with logged-in user' do
    let!(:header_param) { auth_headers(user) }

    context 'with correct params' do
      context 'with valid values' do
        let!(:user_param) do
          {
            first_name: user.first_name,
            last_name: user.last_name,
            gender: user.gender
          }
        end

        it 'returns a success code' do
          update_registration
          expect(response).to have_http_status(:success)
        end

        it 'returns the updated user' do
          update_registration
          res = parsed_response
          expect(res).to include_json(data: user_param)
        end
      end

      context 'with invalid values' do
        let!(:user_param) do
          {
            first_name: 'first_name_that_is_too_long_and_not_accepted',
            last_name: 'last_name_that_is_too_long_and_not_accepted',
            gender: 'invalid_gender'
          }
        end

        it 'returns an error code' do
          update_registration
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the error message' do
          update_registration
          res = parsed_response
          expected_response = {
            errors: {
              gender: ['is not included in the list'],
              first_name: ['is too long (maximum is 20 characters)'],
              last_name: ['is too long (maximum is 20 characters)']
            }
          }
          expect(res).to include_json(expected_response)
        end
      end
    end

    context 'with invalid params' do
      let!(:user_param) do
        {
          email: 'email@email.com'
        }
      end

      it 'returns error status' do
        update_registration
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        update_registration
        json = parsed_response
        expected_response = {
          error: 'Please submit proper account update data in request body.'
        }
        expect(json).to include_json(expected_response)
      end
    end
  end
end
