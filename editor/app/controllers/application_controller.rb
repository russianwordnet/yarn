class ApplicationController < ActionController::Base
  protect_from_forgery

  def words
    render json: Word.all
  end
end
