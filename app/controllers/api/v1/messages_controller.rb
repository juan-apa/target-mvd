module Api
  module V1
    class MessagesController < ApiController
      def create
        raise ActiveRecord::RecordNotFound unless user_conversation_match

        @message = user_conversation_match.conversation.messages.create!(create_params)
      end

      def index
        @messages = user_conversation_match.conversation.ordered_messages.page(params[:page])
      end

      private

      def user_conversation_match
        Match.distinct.matches_with_user_creator_or_compatible(current_user)
             .where(conversation_id: params[:conversation_id])
             .first
      end

      def create_params
        params.require(:message).permit(:body).merge(user: current_user, read: false)
      end
    end
  end
end
