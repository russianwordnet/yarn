# encoding: utf-8

class WordsController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :update]
  before_filter :find_word, :except => [:index, :search]
  before_filter :set_top_bar_word, :except => [:index, :search]
  before_filter :extract_query, :only => :search
  before_filter :track_word, :only => :update

  def index
    @words = Word.order(:word).page params[:page]
  end

  def search
    field = Word.arel_table[:word]
    @words = Word.where(field.matches(@query)).page params[:page]
  end

  def update
    if @word.update_from(@new_word)
      flash[:notice] = 'Слово обновлено.'
      redirect_to word_url(@word)
    else
      flash[:alert] = 'Не получилось обновить слово.'
      render action: 'edit'
    end
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

  def track_word
    attributes = @word.attributes
    attributes.merge! params[:word]
    attributes['author_id'] = current_user.id
    @new_word = OpenStruct.new(attributes)
  end
end
