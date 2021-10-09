module Api
  class MicropostsController < ApplicationController
    before_action :authorized, only: [:create, :destroy, :update]
    before_action :activated_current_user, only: [:create, :destroy, :update]
    before_action :set_variable, only: [:destroy, :show, :update, :liked]
    before_action :correct_user, only: [:destroy, :update]

    def show
      @gravator_url = gravator_for(@user)
      render "microposts/show", formats: :json, handlers: "jbuilder"
    end

    def create
      micropost = @current_user.microposts.build(micropost_params)
      # @micropost.image.attach(params[:micropost][:image])
      if micropost.save
        if micropost.image.attached?
          render json: { micropost: micropost, image: url_for(micropost.image), message: "Micropost  created with Image" }, status: :ok
        else
          render json: { micropost: micropost, message: "Micropost created" }, status: :ok
        end
      else
        render json: { micropost: micropost, message: "Fail to create Micropost" }, status: :bad_request
      end
    end

    def update
      if @micropost.update(micropost_params)
        render json: { micropost: @micropost, message: "Micropost updated Successfully" }
      else
        render json: { micropost: @micropost, message: "Fail to create Micropost" }, status: :bad_request
      end
    end

    def destroy
      if @current_user == @user || @current_user.admin?
        @micropost.destroy
        render json: { message: "Micropost deleted" }, status: :accepted
      else
        render json: { message: "You are not correct user" }, status: :unprocessable_entity
      end
    end

    def liked
      @liked_users = @micropost.liked_users
      render "microposts/liked", formats: :json, handlers: "jbuilder"
    end

    private

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end

    def set_variable
      @micropost = Micropost.find(params[:id])
      @user = User.find(@micropost.user_id)
    end
  end
end
