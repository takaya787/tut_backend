module Api
  class UsersController < ApplicationController
    before_action :set_user, only: [ :show, :update, :destroy]
    # GET /users
    def index
      @users = User.all
      render 'users/index.json.jbuilder', status: :ok
    end

    # GET /users/1
    def show
      render json: {id: @user.id, name: @user.name, email: @user.email,gravator_url: gravator_for(@user)}, status: :ok
    end

    # POST /users
    def create
      @user = User.new(user_params)
      if @user.save
        payload = {user_id: @user.id}
        token = encode_token(payload)
        render json: {user: @user, token: token,gravator_url: gravator_for(@user)}, status: :created, location: api_user_url(@user)
      else
        render json: { errors: @user.errors}, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/1
    def update
      if @user.update(user_params)
        render json: {id: @user.id, name: @user.name, email: @user.email,gravator_url: gravator_for(@user)},status: :ok, location: api_user_url(@user)
      else
        render json: { errors: @user.errors}, status: :unprocessable_entity
      end
    end

    # DELETE /users/1
    def destroy
      @user.destroy
      render json: {message: 'User is deleted successfully'},status: :Accepted
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def user_params
        params.require(:user).permit(:name, :email, :password,:password_confirmation)
      end

  end
end
