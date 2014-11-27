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

  def me
    status = (current_user ? :ok : :unauthorized)
    respond_to do |format|
      format.json{ render(:me, formats: [:json], status: status) }
    end
  end

  protected
  def compute_statistics!
    @stats = User.scores(@user.id).first
    @synsets = Synset.joins_initiators.where(deleted_at: nil,
      current_synsets_initiators: { initiator_id: @user })
  end
end
