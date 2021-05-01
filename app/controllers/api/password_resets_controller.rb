module Api
  class PasswordResetsController < ApplicationController

    #Post /password_reset
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

    #Get /password_reset/:id/edit
    def edit
      render "users/password_reset.html.erb",status: :ok
    end
  end
end
