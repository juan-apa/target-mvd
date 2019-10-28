module Api
  module V1
    class ContactsController < ApiController
      def create
        ContactMailer.send_question(create_params).deliver
        @email = create_params
      end

      private

      def create_params
        params.permit(%i[subject body]).to_h.merge(from: current_user.email).symbolize_keys
      end
    end
  end
end
