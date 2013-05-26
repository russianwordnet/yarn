class WordsController < ApplicationController
  before_filter :find_word, :only => :show
  before_filter :set_top_bar_word, :only => :show
  before_filter :extract_query, :only => :search

  def index
    @words = Word.order(:word).page params[:page]
  end

  def search
    field = Word.arel_table[:word]
    @words = Word.where(field.matches(@query)).page params[:page]
  end

  protected
  def find_word
    @word = Word.find(params[:id])
  end

  def set_top_bar_word
    self.top_bar_word = @word
  end

  def extract_query
    unless params[:q].present?
      redirect_to words_url
      return false
    end

    @query = params[:q].split.map! { |s| '%%%s%%' % s }.join ' '
  end
end
