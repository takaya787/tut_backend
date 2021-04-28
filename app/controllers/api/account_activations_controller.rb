module Api
  class AccountActivationsController < ApplicationController
    #userを有効化する時にclickされるaction
    def edit
      render json: {message: 'Your account is activated!'}
    end
  end
end
