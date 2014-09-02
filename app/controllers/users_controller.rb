class UsersController < ApplicationController
  before_filter :authenticate_user!, only: %i(profile)
  after_filter :compute_statistics, only: %i(profile show)

  def profile
    @user = current_user
    render :show
  end

  def show
    @user = User.find(params[:id])
  end

  protected
  def compute_statistics
    @stats = User.scores(@user.id).first
    @synsets = Synset.by_author(@user)
  end
end
