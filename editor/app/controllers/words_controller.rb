class WordsController < ApplicationController
  before_filter :find_word, :only => :show
  before_filter :set_top_bar_word, :only => :show

  def index
    @words = Word.order(:word).page params[:page]
  end

  protected
  def find_word
    @word = Word.find(params[:id])
  end

  def set_top_bar_word
    self.top_bar_word = @word
  end
end
