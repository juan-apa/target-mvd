require 'rails_helper'

describe 'GET /api/v1/about', type: :request do
  let!(:about) { create :about }
  subject(:request) { get api_v1_about_path, as: :json }

  context 'with signed-out user' do
    it 'returns success code' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns the abouts content' do
      subject
      expect(parsed_response).to include_json(about: about.content)
    end
  end
end
