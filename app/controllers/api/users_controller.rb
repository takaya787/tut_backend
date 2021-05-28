module Api
  class UsersController < ApplicationController
    before_action :authorized, only: [:update, :destroy]
    before_action :activated_current_user, only:[:update,:destroy]
    before_action :set_user, except: [ :index, :create]
    before_action :correct_user, only: [:update, :destroy]

    # GET /users
    def index
      @users = User.where(activated: true).order(:created_at)

      render 'users/index', formats: :json, handlers: 'jbuilder'
    end

    # GET /users/:id
    def show
      @gravator_url = gravator_for(@user)
      @following_count = @user.following.count
      @followers_count = @user.followers.count
      @microposts = @user.microposts.with_attached_image

      render 'users/show', formats: :json, handlers: 'jbuilder'
    end

    # POST /users
    def create
      @user = User.new(user_params)
      if @user.save
        @user.send_activation_email
        payload = {user_id: @user.id}
        token = encode_token(payload)
        render json: {user: @user, token: token,gravator_url: gravator_for(@user)}, status: :created, location: api_user_url(@user)
      else
        render json: { errors: @user.errors}, status: :bad_request
      end
    end

    # PATCH/PUT /users/:id
    def update
      if @user.update(user_params)
        render json: {id: @user.id, name: @user.name, email: @user.email,gravator_url: gravator_for(@user)},status: :ok, location: api_user_url(@user)
      else
        render json: { errors: @user.errors}, status: :bad_request
      end
    end

    # DELETE /users/:id
    def destroy
      @user.destroy
      render json: {message: 'User is deleted successfully'},status: :accepted
    end

    # GET /users/:id/following
    def following
      @following = @user.following
      @gravator_url = gravator_for(@user)
      render 'users/following.jbuilder'
    end

    # GET /users/:id/followers
    def followers
      @followers = @user.followers
      @gravator_url = gravator_for(@user)
      render 'users/followers.jbuilder'
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
