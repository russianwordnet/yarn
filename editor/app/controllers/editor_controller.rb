# encoding: utf-8

class EditorController < ApplicationController
  before_filter :authenticate_user!
  before_filter :extract_query, :only => :search

  layout 'editor'

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

  def word
    @word = Word.find(params[:word_id])

    @raw_synsets = @word.raw_synset_words.map(&:synsets).flatten.uniq
    @definitions = @raw_synsets.map(&:definitions).flatten.uniq
    @synset_words = @raw_synsets.map(&:words).flatten.uniq
    @synonymes = @synset_words.map(&:word).uniq

    @synsets = @word.synset_words.map(&:synsets).flatten.uniq

    respond_with @word, @definitions, @synonymes, @synsets
  end

  def create_synset
    @word = Word.find(params[:word_id])

    @synset_word = SynsetWord.new(word: @word)
    @synset = Synset.new

    Synset.transaction do
      @synset_word.author = current_user
      @synset_word.save!

      @synset.author = current_user
      @synset.words_ids << @synset_word.id
      @synset.save!
    end

    @synsets = @word.synset_words.map(&:synsets).flatten.uniq

    respond_with @synsets
  end
end
