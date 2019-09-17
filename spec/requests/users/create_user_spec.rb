require 'rails_helper'

describe 'POST api/v1/users/', type: :request do
  let(:user)            { User.last }
  let(:failed_response) { 422 }

  describe 'POST create' do
    let(:username)              { 'japaricio' }
    let(:email)                 { 'japaricio@p4e.com' }
    let(:password)              { 'password' }
    let(:password_confirmation) { 'password' }
    let(:first_name)            { 'Juan' }
    let(:last_name)             { 'Aparicio' }
    let(:gender)                { 'male' }

    let(:params) do
      {
        user: {
          email: email,
          password: password,
          password_confirmation: password_confirmation,
          first_name: first_name,
          last_name: last_name,
          gender: gender
        }
      }
    end

    it 'returns a successful response' do
      post user_registration_path, params: params, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'creates the user in the database' do
      expect {
        post user_registration_path, params: params, as: :json
      }.to change(User, :count).by(1)
    end

    it 'returns the user' do
      post user_registration_path, params: params, as: :json

      json = parsed_response
      expect(json[:status]).to eq('success')
      expect(json[:data][:id]).to eq(user.id)
      expect(json[:data][:email]).to eq(user.email)
      expect(json[:data][:uid]).to eq(email)
      expect(json[:data][:provider]).to eq('email')
      expect(json[:data][:first_name]).to eq(user.first_name)
      expect(json[:data][:last_name]).to eq(user.last_name)
      expect(json[:data][:gender]).to eq(user.gender)
    end

    context 'when the email is not correct' do
      let(:email) { 'invalid_email' }

      it 'does not create a user' do
        expect {
          post user_registration_path, params: params, as: :json
        }.not_to change { User.count }
      end

      it 'does not return a successful response' do
        post user_registration_path, params: params, as: :json

        expect(response.status).to eq(failed_response)
      end
    end

    context 'when the password is incorrect' do
      let(:password)              { 'asd' }
      let(:password_confirmation) { 'asd' }
      let(:new_user)              { User.find_by(email: email) }

      it 'does not create a user' do
        post user_registration_path, params: params, as: :json

        expect(new_user).to be_nil
      end

      it 'does not return a successful response' do
        post user_registration_path, params: params, as: :json

        expect(response.status).to eq(failed_response)
      end
    end

    context 'when passwords don\'t match' do
      let(:password)              { 'password1' }
      let(:password_confirmation) { 'password2' }
      let(:new_user)              { User.find_by(email: email) }

      it 'does not create a user' do
        post user_registration_path, params: params, as: :json

        expect(new_user).to be_nil
      end

      it 'does not return a successful response' do
        post user_registration_path, params: params, as: :json

        expect(response.status).to eq(failed_response)
      end
    end

    context 'when the gender is not correct' do
      let(:gender) { 'invalid_gender' }

      it 'does not create a user' do
        expect {
          post user_registration_path, params: params, as: :json
        }.not_to change { User.count }
      end

      it 'does not return a successful response' do
        post user_registration_path, params: params, as: :json

        expect(response.status).to eq(failed_response)
      end
    end
  end
end
