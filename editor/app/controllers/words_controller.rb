class WordsController < ApplicationController
  before_filter :find_word, :only => :show

  def index
    @words = Word.order(:word).page params[:page]
  end

  protected
  def find_word
    @word = Word.find(params[:id])
  end
end
