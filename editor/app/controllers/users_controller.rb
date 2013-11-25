class UsersController < ApplicationController
  def show
    @stats = User.scores(current_user.id).first
  end
end
