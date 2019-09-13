class UserController < ApplicationController
  def index
    User.all
  end

  def show; end

  def destroy; end

  def update; end

  def create; end

  private

  def user_params
    params.require(:user).permit(:email, :gender, :password, :password_confirmation)
  end
end
