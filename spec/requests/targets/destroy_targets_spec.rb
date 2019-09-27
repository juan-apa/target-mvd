require 'rails_helper'

describe 'DELETE api/v1/targets/:id', type: :request do
  let!(:user)    { create :user }
  let!(:target)  { create :target, user: user }
  let!(:headers) { auth_headers(user) }
  let(:invalid_target_id) { 'invalid_target_id' }

  context 'with signed-out user' do
    before do
      delete api_v1_target_path(target.id), headers: {}, as: :json
    end

    it 'returns an error code' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns an error message' do
      json = parsed_response
      expected_response = {
        errors: ['You need to sign in or sign up before continuing.']
      }
      expect(json).to include_json(expected_response)
    end
  end

  context 'with signed-in user' do
    context 'with valid target id' do
      it 'changes the amount of targets by one' do
        expect {
          delete api_v1_target_path(target.id), headers: headers, as: :json
        }.to change(Target, :count).by(-1)
      end

      it 'returns a success code' do
        delete api_v1_target_path(target.id), headers: headers, as: :json
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid target id' do
      it 'doesn\'t change the amount of targets' do
        expect {
          delete api_v1_target_path(invalid_target_id), headers: headers, as: :json
        }.not_to change(Target, :count)
      end

      it 'returns not found status' do
        delete api_v1_target_path(invalid_target_id), headers: headers, as: :json
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        delete api_v1_target_path(invalid_target_id), headers: headers, as: :json
        json = parsed_response
        expected_response = {
          error: 'Couldn\'t find the record'
        }
        expect(json).to include_json(expected_response)
      end
    end
  end
end
