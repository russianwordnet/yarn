class UsersController < ApplicationController
  def show
    @stats = User.statistics(id).first
  end
end
