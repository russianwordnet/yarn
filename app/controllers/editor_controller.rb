# encoding: utf-8

class EditorController < ApplicationController
  before_filter :authenticate_user!, except:
    [:index, :word, :show_synset, :definitions, :synonymes]
  before_filter :timestamp_required, only: [:edit_marks, :save]

  layout proc {|controller| controller.request.xhr? ? false : "editor" }
  respond_to :html, :json

  def index
    @words = if params[:word].present?
      Word.search(params[:word]).
        order(['rank DESC', 'frequency DESC', 'word'])
    else
      Word.joins(:score).
        order(['score DESC', 'word'])
    end

    @words = @words.where(deleted_at: nil).page(params[:page])

    respond_with @words do |format|
      format.html do
        options = if request.xhr?
          { :partial => 'editor/index/word_picker_listing', :locals => { :words => @words } }
        else
          @marks_categories = MarkCategory.includes(:marks).load
          'index'
        end

        render options
      end
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

  def word
    @word = if params[:next].present?
      Word.next_word(params[:word_id])
    else
      Word.find(params[:word_id])
    end

    @raw_synonyms = @word.raw_synonyms.where(deleted_at: nil).to_a.prepend(@word)
    @synonyms_definitions =  Definition.select('current_definitions.*, word_id').
                                        joins(:raw_definition).
                                        where(raw_definitions: {word_id: @raw_synonyms.map(&:id)}).
                                        where(deleted_at: nil).
                                        group_by { |d| d.word_id.to_i }

    build_samples

    @synsets = @word.synset_words.map(&:synsets).flatten.uniq

    respond_with @word, @definitions, @synsets, @samples
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

  def update_definition
    synset = Synset.find(params[:id])
    @definition = synset.default_definition || Definition.new

    @definition.update_with_tracking(params[:definition].permit(:text, :source, :uri))

    synset.update_with_tracking(default_definition_id: @definition.id) if synset.default_definition.blank?
  end

  def create_sample
    synset_word = SynsetWord.find(params[:synset_word_id])

    @sample = Sample.new(params[:sample])
    @sample.author = current_user
    @sample.save!

    synset_word.update_with_tracking(author: current_user) {|synset| synset.examples_ids += [@sample.id] }

    render 'create_sample'
  end

  def show_synset
    @synset = Synset.find(params[:synset_id])

    @definitions = @synset.definitions
    @words = @synset.words.map(&:word)

    render :create_synset
  end

  def set_default_definition
    @synset = Synset.find(params[:synset_id])
    @definition = Definition.find(params[:definition_id])
    @synset.update_with_tracking(author: current_user) {|s| s.default_definition = @definition }

    show_synset
  end

  def set_default_synset_word
    @synset = Synset.find(params[:synset_id])
    @synset_word = SynsetWord.find(params[:synset_word_id])
    @synset.update_with_tracking(author: current_user) {|s| s.default_synset_word = @synset_word }

    show_synset
  end

  def edit_marks
    synset_word = SynsetWord.find(params[:synset_word_id])
    return head 409 if params[:timestamp].to_f < synset_word.updated_at.to_f

    synset_word.update_with_tracking(marks_ids: Array.wrap(params[:marks]).map(&:to_i), author: current_user)

    show_synset
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
    return head 409 if params[:timestamp].to_f < @synset.updated_at.to_f

    # retrieve existent word associations
    words_mapping = @synset.words.inject({}) do |h, sw|
      h[sw.word_id] = sw; h
    end

    # the word 'lexeme' is used to distinguish `synset_word` from `word`
    lexemes = (params[:lexemes].values || [])

    words_ids = lexemes.map do |word|
      synset_word = if words_mapping[word[:id].to_i]
        words_mapping[word[:id].to_i]
      else
        synset_word = SynsetWord.new
        synset_word.word_id = word[:id]
        synset_word.author = current_user

        synset_word
      end

      synset_word.update_with_tracking do |s|
        s.examples_ids = Array.wrap(word[:samples]).map(&:to_i)
        s.definitions_ids = Array.wrap(word[:definitions]).map(&:to_i)
      end
      synset_word.reload

      synset_word.id
    end

    @synset.update_with_tracking(author: current_user) do |synset|
      synset.words_ids = words_ids
      synset.default_definition_id = params[:definition][:id] if params[:definition].present?
    end
    @synset.reload
    render 'create_synset'
  end

  protected

  def build_samples
    definition_ids = @synonyms_definitions.values.flatten.map(&:id)

    @samples = Sample.select('current_examples.*, definition_id').
                      joins(:raw_example => :raw_definition).
                      where(raw_definitions: {definition_id: definition_ids}).
                      group_by(&:definition_id)

    @samples.inject({}) do |hash, (definition_id, samples)|
      hash[definition_id] = samples.map! {|sample| {id: sample.id, text: '%s (%s)' % [sample.text, sample.source || 'н/д']} }

      hash
    end
  end

  def timestamp_required
    head 500 unless params[:timestamp].present?
  end
end
