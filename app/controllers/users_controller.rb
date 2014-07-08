class UsersController < ApplicationController
  def show
    @stats = User.scores(current_user.id).first
    @synsets = Synset.by_author(current_user)
  end
end
