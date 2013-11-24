class UsersController < ApplicationController
  def show
    @stats = User.statistics(current_user.id).first
  end
end
