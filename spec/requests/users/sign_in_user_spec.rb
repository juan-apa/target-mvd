require 'rails_helper'

describe 'POST /api/v1/users/sign_in', type: :request do
  # Create and confirm a user in the database
  let(:user) { create(:user) }

  context 'with correct params and confirmed email' do
    before do
      user.confirm
      user.reload
      params = {
        email: user.email,
        password: user.password
      }
      post '/api/v1/users/sign_in', params: params, as: :json
    end
    it 'returns success' do
      expect(response).to be_successful
    end

    it 'returns the user' do
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:id]).to eq(user.id)
      expect(json[:data][:email]).to eq(user.email)
      expect(json[:data][:uid]).to eq(user.email)
      expect(json[:data][:provider]).to eq('email')
      expect(json[:data][:first_name]).to eq(user.first_name)
      expect(json[:data][:last_name]).to eq(user.last_name)
      expect(json[:data][:gender]).to eq(user.gender)
    end

    it 'returns a valid client and access token' do
      token = response.header['access-token']
      client = response.header['client']
      expect(user.reload.valid_token?(token, client)).to be_truthy
    end
  end

  context 'with unconfirmed email' do
    before do
      params = {
        email: user.email,
        password: user.password
      }
      post '/api/v1/users/sign_in', params: params, as: :json
    end
    it 'returns unauthorized' do
      expect(response).to be_unauthorized
    end

    it 'returns invalid email message' do
      json = JSON.parse(response.body)
      expected_response = {
        success: false,
        errors: ['A confirmation email was sent to your account at \'' + user.email +
          '\'. You must follow the instructions in the email before your account can be activated']
      }.with_indifferent_access
      expect(json).to eq(expected_response)
    end
  end

  context 'with incorrect params and confirmed email' do
    before do
      user.confirm
      user.reload
      params = {
        email: user.email,
        password: user.password + 'wrong_password'
      }
      post '/api/v1/users/sign_in', params: params, as: :json
    end

    it 'returns unauthorized' do
      expect(response).to be_unauthorized
    end

    it 'return errors upon failure' do
      json = JSON.parse(response.body)
      expected_response = {
        success: false,
        errors: ['Invalid login credentials. Please try again.']
      }.with_indifferent_access
      expect(json).to eq(expected_response)
    end
  end
end
