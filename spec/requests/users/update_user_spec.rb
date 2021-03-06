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
        let!(:new_user_attr) { build :user }
        let!(:user_param) do
          {
            first_name: new_user_attr.first_name,
            last_name: new_user_attr.last_name,
            gender: new_user_attr.gender
          }
        end

        it 'returns a success code' do
          update_registration
          expect(response).to have_http_status(:success)
        end

        it 'returns the updated user' do
          update_registration
          res = parsed_response
          expect(res).to include_json(user: user_param)
        end

        it 'changes the values' do
          expect {
            update_registration
            user.reload
          }.to change { [user.first_name, user.last_name, user.gender] }
            .from([user.first_name, user.last_name, user.gender])
            .to([new_user_attr.first_name, new_user_attr.last_name, new_user_attr.gender])
        end
      end

      context 'with avatar field' do
        let!(:header_param) { auth_headers(user).merge(accept: 'application/json') }
        let!(:avatar_img) { fixture_file_upload('spec/fixtures/test_image.png', 'image/png') }
        subject(:update_registration) do
          patch user_registration_path,
                params: { user: { avatar: avatar_img } },
                headers: header_param
        end

        it 'returns a success code' do
          subject
          expect(response).to have_http_status(200)
        end

        it 'changes the user\'s avatar' do
          expect { subject }.to change { url_for(User.find(user.id).avatar) }
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

        it 'doesn\'t change the values' do
          expect {
            update_registration
            user.reload
          }.not_to change { [user.first_name, user.last_name, user.gender] }
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

      it 'doesn\'t change the values' do
        expect {
          update_registration
          user.reload
        }.not_to change { [user.first_name, user.last_name, user.gender, user.email] }
      end
    end
  end
end
