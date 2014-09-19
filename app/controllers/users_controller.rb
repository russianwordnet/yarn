class UsersController < ApplicationController
  before_filter :authenticate_user!, only: %i(profile)

  def profile
    @user = current_user
    compute_statistics!
    render :show
  end

  def show
    @user = User.find(params[:id])
    compute_statistics!
  end

  protected
  def compute_statistics!
    @stats = User.scores(@user.id).first
    @synsets = Synset.by_author(@user)
  end
end
