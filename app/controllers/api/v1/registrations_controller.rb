module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      protect_from_forgery with: :exception
      include Api::Concerns::ActAsApiRequest
      skip_before_action :check_json_request, only: :update

      def update
        super()
      end

      private

      def render_create_success
        render 'api/v1/registrations/create'
      end

      def render_update_success
        render 'api/v1/registrations/update'
      end

      def sign_up_params
        params.require(:user).permit(:first_name, :last_name, :email, :gender, :password,
                                     :password_confirmation)
      end

      def account_update_params
        params.require(:user).permit(:first_name, :last_name, :gender, :notification_token, :avatar)
      end
    end
  end
end
