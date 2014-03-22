class UsersController < ApplicationController
  def show
    @stats = User.scores(current_user.id).first
    @synsets = Synset.retrieve_creators.
      find { |u, _| u == current_user }.
      try(:last)
  end
end
