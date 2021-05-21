module Api
  class AuthController < ApplicationController
    before_action :authorized, only: [:auto_login,:auto_relationships]
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
    # get '/auto_login',
    def auto_login
      @gravator_url = gravator_for(@current_user)
      @current_microposts = @current_user.microposts.with_attached_image
      render 'users/auto_login.jbuilder'
    end

    # get '/auto_relationships',
    # relationship情報を取得する
    def auto_relationships
      @following = @current_user.following
      @followers = @current_user.followers
      @following_index = @following.pluck("id")
      @followers_index = @followers.pluck("id")
      render 'users/auto_relationships.jbuilder'
      # render json:{following: @following, followers: @followers,user: @current_user}
    end
  end
end
