module Api
  module V1
    class ContactController < ApiController
      def send_question
        ContactMailer.send_question(send_question_params).deliver
      end

      private

      def send_question_params
        params.permit(%i[subject body]).to_h.merge(from: current_user.email).symbolize_keys
      end
    end
  end
end
