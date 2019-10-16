require 'rails_helper'

describe 'POST api/v1/conversations/:conversation_id/messages', type: :request do
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
  let(:headers) { {} }
  let!(:message) { build :message, conversation_id: conversation_id }

  subject do
    post api_v1_conversation_messages_path(conversation_id),
         params: message,
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

    context 'with correct params' do
      it 'changes the amount of messages by one' do
        expect {
          subject
        }.to change(Message, :count).by(1)
      end

      it 'returns a success code' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns the message' do
        subject
        json = parsed_response
        expected_response = {
          message: {
            conversation_id: conversation_id,
            user_id: target_2.user.id,
            body: message.body
          }
        }
        expect(json).to include_json(expected_response)
      end

      it 'sends a notification to the other user' do
        allow(NotificationService).to receive(:new_message_notification)
      end
    end

    context 'with incorrect params' do
      context 'with non existant conversation id' do
        let!(:conversation_id) { 'invalid_conversation_id!' }

        it 'returns not found' do
          subject
          expect(response).to have_http_status(:not_found)
        end

        it 'returns error message' do
          subject
          expected_response = {
            error: 'Couldn\'t find the record'
          }
          expect(parsed_response).to include_json(expected_response)
        end
      end

      context 'with empty body' do
        let(:message) { { conversation_id: conversation_id, body: nil, user_id: user_2 } }

        it 'returns bad request status' do
          subject
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an empty body error message' do
          subject
          expected_response = {
            errors: {
              body: ['can\'t be blank']
            }
          }
          expect(parsed_response).to include_json(expected_response)
        end
      end
    end
  end
end
