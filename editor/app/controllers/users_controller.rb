class UsersController < ApplicationController
  def show
    @stats = User.score(current_user.id).first
  end
end
