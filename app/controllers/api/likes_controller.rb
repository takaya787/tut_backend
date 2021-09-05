module Api
  class LikesController < ApplicationController
    before_action :authorized
    before_action :set_variable
    before_action :correct_user, only: [:destory]

    def create
      like = @micropost.likes.build(user_id: @current_user.id)
      if like.save
        render json: { message: "like microposts successfully" }, status: :ok
      else
        render json: { micropost: @micropost, current_user: @current_user, message: "Fail to like micropost" }, status: :bad_request
      end
    end

    def destroy
    end

    private

    def set_variable
      @micropost = Micropost.find(params[:id])
    end

    def correct_user
    end
  end
end
