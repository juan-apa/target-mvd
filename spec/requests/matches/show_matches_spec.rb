require 'rails_helper'

describe 'GET /api/v1/matches/:id', type: :request do
  let!(:user_1)   { create :user }
  let!(:user_2) { create :user }
  let!(:target_1) { create :target, user: user_1 }
  let!(:target_2) do
    create :target,
           radius: target_1.radius,
           latitude: target_1.latitude,
           longitude: target_1.longitude,
           topic_id: target_1.topic.id,
           user: user_2
  end

  context 'with signed-out user' do
    subject { get api_v1_match_path(target_2.matches_creators.last), as: :json }

    it 'returns unauthorized' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns error message' do
      subject
      json = parsed_response
      expect(json).to include_json(errors: ['You need to sign in or sign up before continuing.'])
    end
  end

  context 'with signed-in user' do
    let(:headers) { auth_headers(user_2) }

    context 'with invalid match id' do
      subject { get api_v1_match_path('invalid_match_id!'), headers: headers, as: :json }

      it 'returns a not found status' do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        subject
        expect(parsed_response).to include_json(error: 'Couldn\'t find the record')
      end
    end

    context 'with valid match id' do
      subject { get api_v1_match_path(target_2.matches_creators.last), headers: headers, as: :json }

      it 'returns a success status' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns the match' do
        subject
        match = {
          target_creator_id: target_2.id,
          target_compatible_id: target_1.id,
          user_creator_id: user_2.id,
          user_compatible_id: user_1.id
        }
        expect(parsed_response).to include_json(match: match)
      end
    end
  end
end
