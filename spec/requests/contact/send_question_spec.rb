require 'rails_helper'

describe 'GET /api/v1/matches/:id', type: :request do
  subject { post api_v1_contact_path, params: params, headers: headers, as: :json }
  let!(:params) do
    {
      subject: 'Email subject',
      body: 'Email body'
    }
  end
  let!(:admin_user) { create :admin_user }

  context 'with signed-out user' do
    let!(:headers) { {} }

    it 'returns unauthorized' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns error message' do
      subject
      expected_response = { errors: ['You need to sign in or sign up before continuing.'] }
      expect(parsed_response).to include_json(expected_response)
    end
  end

  context 'with signed-in user' do
    let!(:user) { create :user }
    let!(:headers) { auth_headers(user) }

    it 'returns a success code' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'sends an email to admin_user' do
      allow(ContactMailer).to receive(:send_question)
    end
  end
end
