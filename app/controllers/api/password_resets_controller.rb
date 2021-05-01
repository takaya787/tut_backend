module Api
  class PasswordResetsController < ApplicationController

    def create
      @user = User.find_by(email: params[:password_reset][:email].downcase)
      if @user
        @user.create_reset_digest
        @user.send_password_reset_email
        render json: {message:"Email sent with password reset instructions"}, status: :ok
      else
        render json: {message:"Email address not found"}, status: :bad_request
      end
    end

    def edit
    end
  end
end
