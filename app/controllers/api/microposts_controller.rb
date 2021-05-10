module Api
  class MicropostsController < ApplicationController
    before_action :authorized, only: [:create, :destroy]
    before_action :activated_current_user, only:[:create,:destroy]
    before_action :set_variable, only: [:destroy]
    before_action :correct_user, only: [:destroy]
    def create
      micropost = @current_user.microposts.build(micropost_params)
      if micropost.save
        render json: { micropost: micropost, message: 'Micropost created'},status: :ok
      else
        render json: { micropost: micropost, message: 'Fail to create Micropost'},status: :bad_request
      end
    end

    def destroy
      if @current_user == @user || @current_user.admin?
        @micropost.destroy
        render json: {message: 'Micropost deleted'},status: :accepted
      else
        render json: {message: 'You are not correct user'},status: :unprocessable_entity
      end
    end

    private
      def micropost_params
        params.require(:micropost).permit(:content)
      end

      def set_variable
        @micropost = Micropost.find(params[:id])
        @user = User.find(@micropost.user_id)
      end

  end
end
