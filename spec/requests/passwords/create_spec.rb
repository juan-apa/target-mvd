require 'rails_helper'

describe 'POST api/v1/users/passwords/', type: :request do
  let!(:user) { create :user }
  subject(:reset_password) { post user_password_path, params: params }

  context 'with valid params' do
    let(:params) { { email: user.email } }

    it 'returns a success status' do
      reset_password
      expect(response).to have_http_status(:success)
    end

    it 'sends an email' do
      expect {
        reset_password
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  context 'with invalid params' do
    let(:params) { { email: 'non_existant_email' } }

    it 'returns not found status code' do
      reset_password
      expect(response).to have_http_status(:not_found)
    end

    it 'doesn\'t send an email' do
      expect {
        reset_password
      }.not_to change { ActionMailer::Base.deliveries.count }
    end
  end
end
