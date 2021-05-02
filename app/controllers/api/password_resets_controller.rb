module Api
  class PasswordResetsController < ApplicationController
    before_action :get_user, only:[:edit,:update]
    before_action :valid_user, only:[:edit,:update]

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

    #Put /password_reset/:id
    def update
      if @user.update(user_params)
        render "users/password_reset.html.erb"
      end
    end

    private
      def user_params
        params.require(:user).permit(:password, :password_confirmation)
      end

      def get_user
        email = CGI.unescape(params[:email])
        @user = User.find_by(email: email)
      end

      # 正しいユーザーかどうか確認する
      def valid_user
        # unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        #   render json: {message:"You are not correct user"}, status: :bad_request
        # end
        unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
          render json: {message:"You are not correct user"}, status: :bad_request
        end
      end
  end
end
