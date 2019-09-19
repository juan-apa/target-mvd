module Api
  module V1
    class UsersController < ApiController
      def show
        @user = User.find(params[:id])
      end

      def index
        @users = User.all
      end
    end
  end
end
