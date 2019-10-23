require 'koala'

module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      protect_from_forgery with: :null_session

      def facebook_sign_in
        user_data = FacebookService.new(facebook_sign_in_params).get_user_data
        byebug
        @resource = User.find_or_create_sign_in('facebook', user_data)
        sign_in(:user, @resource)
        new_auth_header = @resource.create_new_auth_token
        response.headers.merge!(new_auth_header)
        render_create_success
      end

      private

      def facebook_sign_in_params
        params[:access_token]
      end

      def resource_params
        params.require(:user).permit(:email, :password)
      end

      def render_create_success
        render json: { user: resource_data }
      end
    end
  end
end
