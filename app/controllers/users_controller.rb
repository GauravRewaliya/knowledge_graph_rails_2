class UsersController < ApplicationController
  def current_user
    render json: { "user": "Gaurav Rewaliya" }
  end
end
