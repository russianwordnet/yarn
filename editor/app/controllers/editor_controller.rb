# encoding: utf-8

class EditorController < ApplicationController
  layout 'editor'
  before_filter :extract_query, :only => :search

  respond_to :html, :json

  def index
    @words = Word.order('frequency DESC').select('id, word').limit(100)
  end

  def search
    field = Word.arel_table[:word]
    @words = Word.where(field.matches(@query)).
      order('frequency DESC', 'word').page params[:page]

    respond_to do |format|
      format.xml { render xml: @words }
      format.json { render json: @words }
    end
  end

  def definitions
    @word = Word.find(params[:word_id])
    @synsets = @word.synset_words.map(&:synsets).flatten.uniq
    @definitions = @synsets.map(&:definitions).flatten.uniq

    respond_to do |format|
      format.xml { render xml: @definitions }
      format.json { render json: @definitions }
    end
  end

  def synonymes
    @word = Word.find(params[:word_id])

    @definition = Definition.find(params[:definition_id])
    @synset_words = @definition.synsets.map(&:words).flatten.uniq

    synonymes = @synset_words.map(&:word).flatten.uniq
    synonymes.reject! { |w| w == @word }

    @synonymes = synonymes.inject({}) do |hash, synonym|
      synsets = synonym.synset_words.map(&:synsets).flatten.uniq
      hash[synonym] = synsets.map(&:definitions).flatten.uniq
      hash
    end

    respond_to do |format|
      format.xml { render xml: @synonymes }
      format.json { render json: @synonymes }
    end
  end

  def append_word
    @word = Word.find(params[:word_id])
  end

  def append_definition
    @definition = Definition.find(params[:definition_id])
  end

  def extract_query
    unless params[:q].present?
      redirect_to words_url
      return false
    end

    @query = params[:q].split.map! { |s| '%s%%' % s }.join ' '
  end

  # Получить данные для левой колонки редактора по слову
  # Формат данных такой:
  #
  # definitions
  #   definition1
  #   definition2
  #   definition3
  # synonymes
  #   synonym1
  #     definition1
  #     definition2
  #     definition3
  #   synonym2
  #     definition1
  #     definition2
  #     definition3
  #   synonym2
  #     definition1
  #     definition2
  #     definition3
  # 
  def word
    # Список определений слова
    @word = Word.find(params[:word_id])
    @raw_synsets = @word.raw_synset_words.map(&:synsets).flatten.uniq
    @definitions = @raw_synsets.map(&:definitions).flatten.uniq

    # Получить синонимы с определениями
    @synset_words = @raw_synsets.map(&:words).flatten.uniq
    @synonymes = @synset_words.map(&:word).uniq

    respond_with @word, @definitions, @synonymes
  end
end
