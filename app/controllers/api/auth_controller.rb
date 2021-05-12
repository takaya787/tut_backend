module Api
  class AuthController < ApplicationController
    before_action :authorized, only: [:auto_login]
    def login
      @user = User.find_by(email: params[:email])
      if @user && @user.authenticate(params[:password])
        payload = {user_id: @user.id}
        token = encode_token(payload)

        render json: {user: {email: @user.email,id: @user.id,name: @user.name, gravator_url: gravator_for(@user)}, token: token}
      else
        render json: {error: 'Invalid username or password'}, status: :unauthorized
      end
    end

    def auto_login
      @gravator_url = gravator_for(@current_user)
      @current_microposts = @current_user.microposts.with_attached_image
      render 'users/auto_login.json.jbuilder'
      # render json: {user: {email: @current_user.email, id: @current_user.id,name: @current_user.name,gravator_url: gravator_for(@current_user),activated: @current_user.activated, activated_at: @current_user.activated_at,microposts: @current_user.microposts }}

    end
  end
end
