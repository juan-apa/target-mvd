module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      protect_from_forgery with: :exception
      skip_before_action :verify_authenticity_token

      private

      def sign_up_params
        params.require(:user).permit(:first_name, :last_name, :email, :gender, :password,
                                     :password_confirmation)
      end
    end
  end
end
