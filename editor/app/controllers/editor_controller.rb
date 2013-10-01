# encoding: utf-8

class EditorController < ApplicationController
  before_filter :authenticate_user!
  before_filter :extract_query, :only => :search

  layout proc {|controller| controller.request.xhr? ? false : "editor" }
  respond_to :html, :json

  def index
    @words = Word.order('frequency DESC').select('id, word')

    if params.key?(:word) && !params[:word].empty?
      query  = params[:word].split.map! { |s| ('%s%%' % s).
        gsub(/[её]/, '(е|ё)').
        gsub(/[ЕЁ]/, '(Е|Ё)') }.join ' '
      @words = @words.where('word SIMILAR TO ?', query)
    end

    @words = @words.page params[:page]

    respond_with @words do |format|
      format.html do
        options = if request.xhr?
          { :partial => 'editor/index/word_picker_listing', :locals => { :words => @words } }
        else
          'index'
        end

        render options
      end
    end
  end

  def search
    @words = Word.where('word SIMILAR TO ?', @query).
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

    @query = params[:q].split.map! { |s| ('%s%%' % s).
      gsub(/[её]/, '(е|ё)').
      gsub(/[ЕЁ]/, '(Е|Ё)') }.join ' '
  end

  def word
    @word = if params[:next].present?
      Word.next_word(params[:word_id])
    else
      Word.find(params[:word_id])
    end

    @raw_synsets = @word.raw_synset_words.map(&:synsets).flatten.uniq
    @definitions = @raw_synsets.map(&:definitions).flatten.uniq
    @synset_words = @raw_synsets.map(&:words).flatten.uniq(&:word_id)
    @synset_words.reject! { |sw| sw.word_id == @word.id }
    @synsets = @word.synset_words.map(&:synsets).flatten.uniq

    respond_with @word, @definitions, @synsets
  end

  def create_synset
    @word = Word.find(params[:word_id])

    @synset_word = SynsetWord.new(word: @word)
    @synset = Synset.new

    Synset.transaction do
      @synset_word.author = current_user
      @synset_word.save!

      @synset.author = current_user
      @synset.words_ids += [@synset_word.id]
      @synset.save!
    end

    @synsets = @word.synset_words.map(&:synsets).flatten.uniq

    render 'create_synset'
  end

  def create_definition
    @synset = Synset.find(params[:synset_id])

    @definition = Definition.new(params[:definition])
    @definition.author = current_user
    @definition.save!

    @new_synset = @synset.dup
    @new_synset.definitions_ids += [@definition.id]

    @synset.update_from(@new_synset, :save!)

    render 'create_definition'
  end

  def show_synset
    @synset = Synset.find(params[:synset_id])

    @definitions = @synset.definitions
    @words = @synset.synset_words.map(&:word)

    respond_with @synset, @definitions, @words
  end

  #   .-´¯¯¯`-.
  # ,´         `.
  # |            \
  # |             \
  # \           _  \
  # ,\  _    ,´¯,/¯)\
  # ( q \ \,´ ,´ ,´¯)
  #  `._,)     -´,-´)
  #    \/         ,´/
  #     )        / /
  #    /       ,´-´
  #
  def save
    @synset = Synset.find(params[:synset_id])
    @new_synset = @synset.dup

    @new_synset.definitions_ids = params[:definitions_ids]
    @new_synset.words_ids = []

    # retrieve existent word associations
    words_mapping = @synset.words.inject({}) do |h, sw|
      h[sw.word_id] = sw; h
    end

    # the word 'lexeme' is used to distinguish `synset_word` from `word`
    lexemes_ids = params[:lexemes_ids].map(&:to_i)

    lexemes_mapping = Word.find(lexemes_ids).inject({}) do |h, w|
      h[w.id] = w; h
    end

    lexemes_ids.each do |word_id|
      if words_mapping[word_id]
        @new_synset.words_ids += [words_mapping[word_id].id]
      else
        synset_word = SynsetWord.new(word: lexemes_mapping[word_id])
        synset_word.author = current_user
        synset_word.save!

        @new_synset.words_ids += [synset_word.id]
      end
    end

    @synset.update_from(@new_synset, :save!)
    @synset.reload

    render 'create_synset'
  end
end
