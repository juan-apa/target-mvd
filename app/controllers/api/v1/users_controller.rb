module Api
  module V1
    class UsersController < ApplicationController
      def show
        user = User.find(params[:id])
        render user.to_json
      end
    end
  end
end
