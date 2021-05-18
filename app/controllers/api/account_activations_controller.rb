module Api
  class AccountActivationsController < ApplicationController
    before_action :authorized, only: [:resend_email]
    #userを有効化する時にclickされるaction
    #get account_activation/:id/edit
    def edit
      email = CGI.unescape(params[:email])
      @user = User.find_by(email: email)
      if @user && @user.authenticated?(:activation, params[:id])
        @user.activate
        render 'users/activation.html.erb', status: :ok
      # elsif @user.activated?
      #   render json: {message: 'Your account is already activated!',user:@user}, status: :ok
      else
        render json: {message: 'Your account failed to be activated'}, status: :unprocessable_entity
      end
    end

    def resend_email
      UserMailer.account_activation(@current_user).deliver_now
      render json: {message: 'The activation email is resent. Please check your email'}
    end

  end
end
