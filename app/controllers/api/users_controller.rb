module Api
  class UsersController < ApplicationController
    # GET /users
    def index
      @users = User.all
      render json: @users, status: :ok
    end

    # GET /users/1
    def show
      @user = User.find(params[:id])
      render json: {id: @user.id, name: @user.name, email: @user.email,gravatar_url: gravator_for(@user)}
    end

    # POST /users
    def create
      @user = User.new(user_params)
      if @user.save
        payload = {user_id: @user.id}
        token = encode_token(payload)
        render json: {user: @user, token: token}, status: :created, location: api_user_url(@user)
      else
        render json: { errors: @user.errors}, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/1
    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # DELETE /users/1
    def destroy
      @user.destroy
      render json: {message: 'User is deleted successfully'},status: :ok
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

      def gravator_for(user)
        gravatar_id = Digest::MD5::hexdigest(user.email)
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
        gravatar_url
      end
  end
end
