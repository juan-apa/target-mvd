module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      protect_from_forgery with: :exception
      include Api::Concerns::ActAsApiRequest

      private

      def sign_up_params
        params.require(:user).permit(:first_name, :last_name, :email, :gender, :password,
                                     :password_confirmation)
      end

      def account_update_params
        params.require(:user).permit(:first_name, :last_name, :gender, :notification_token)
      end
    end
  end
end
