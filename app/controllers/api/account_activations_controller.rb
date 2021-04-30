module Api
  class AccountActivationsController < ApplicationController
    #userを有効化する時にclickされるaction
    def edit
      email = CGI.unescape(params[:email])
      @user = User.find_by(email: email)
      # render json: {message: 'Your account is activated!',user:user}, status: :ok
      if @user && @user.authenticated?(:activation, params[:id])
        @user.update_attribute(:activated,    true)
        @user.update_attribute(:activated_at, Time.zone.now)
        render 'users/activation.html.erb', status: :ok
      # elsif @user.activated?
      #   render json: {message: 'Your account is already activated!',user:@user}, status: :ok
      else
        render json: {message: 'Your account failed to be activated'}, status: :unprocessable_entity
      end
    end
  end
end
