module Api
  class LikesController < ApplicationController
    before_action :authorized
    before_action :set_variable

    def create
      like = @micropost.likes.build(user_id: @current_user.id)
      if like.save
        render json: { message: "like the micropost successfully", micropost: @micropost }, status: :ok
      else
        render json: { micropost: @micropost, current_user: @current_user, message: "Fail to like micropost" }, status: :bad_request
      end
    end

    def destroy
      like = @current_user.liked_microposts.find_by(micropost_id: @micropost.id)
      liking_user = User.find(like.user_id)
      # likeしたuserとcurrent_userが等しいかチェック
      correct_liking_user(liking_user)
      like.destory
      render json: { message: "Like is cancelled successfully" }, status: :accepted
    end

    private

    def set_variable
      micropost_id = params[:micropost_id]
      if micropost_id
        @micropost = Micropost.find(micropost_id)
      else
        render json: { message: "Micropost id params is missing" }, status: :bad_request
      end
    end

    def correct_liking_user(user)
      render json: { message: "You are not correct user" }, status: :forbidden unless !!current_user?(user) || is_admin?(@current_user)
    end
  end
end
