require 'rails_helper'

describe 'GET api/v1/conversations/:conversation_id/messages', type: :request do
  let!(:user_1) { create :user }
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
  let!(:conversation_id) { target_2.matches_creators.first.conversation.id }
  let!(:messages_user_1) { create_list :message, 3, user: user_1, conversation_id: conversation_id }
  let!(:messages_user_2) { create_list :message, 3, user: user_2, conversation_id: conversation_id }
  let!(:headers) { {} }
  let!(:page) { 1 }

  subject do
    get api_v1_conversation_messages_path(conversation_id: conversation_id, page: page),
        headers: headers,
        as: :json
  end

  context 'with logged-out user' do
    it 'returns an error code' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns an error message' do
      subject
      json = parsed_response
      expected_response = {
        errors: ['You need to sign in or sign up before continuing.']
      }
      expect(json).to include_json(expected_response)
    end
  end

  context 'with logged-in user' do
    let!(:headers) { auth_headers(user_2) }
    context 'fetching page 1' do
      it 'returns a success code' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns the messages' do
        subject
        json = parsed_response
        expected_response = (messages_user_1 + messages_user_2).map do |message|
          {
            conversation_id: conversation_id,
            user_id: message.user.id,
            body: message.body,
            sent_at: message.created_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')
          }
        end
        expected_response.sort! { |m1, m2| m2[:sent_at] <=> m1[:sent_at] }

        expect(json).to include_json(messages: expected_response)
      end
    end

    context 'fetching page 2' do
      it 'returns a success code' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns an empty array' do
        subject
        expect(parsed_response).to include_json(messages: [])
      end
    end
  end
end
