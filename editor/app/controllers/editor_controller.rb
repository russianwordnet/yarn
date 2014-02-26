# encoding: utf-8

class EditorController < ApplicationController
  before_filter :authenticate_user!, except:
    [:index, :word, :show_synset, :definitions, :synonymes]

  layout proc {|controller| controller.request.xhr? ? false : "editor" }
  respond_to :html, :json

  def index
    @words = Word.select('id, word, frequency').where(deleted_at: nil)

    if params.key?(:word) && !params[:word].empty?
      (@query = params[:word].gsub(/\p{Zs}{2,}/, ' ')).split.each do |token|
        token.insert(0, '%')
        token.insert(-1, '%')

        if token =~ /[ЕеЁё]/
          yetoken = token.gsub(/[ЕЁ]/, 'Е').gsub(/[её]/, 'е')
          yotoken = token.gsub(/[ЕЁ]/, 'Ё').gsub(/[её]/, 'ё')
          @words = @words.where('word ILIKE ? OR word ILIKE ?', yetoken, yotoken)
        else
          @words = @words.where('word ILIKE ?', token)
        end

        @words = @words.order('frequency DESC, word')
      end
    else
      @words = @words.joins(:score).order('score DESC, word')
    end

    @words = @words.page(params[:page])

    @marks_categories = MarkCategory.includes(:marks).all

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

    @raw_synonyms = @word.raw_synonyms
    @definitions = Definition.joins(:raw_definition).where(raw_definitions: {word_id: @word.id})
    @synonyms_definitions =  Definition.select('current_definitions.*, word_id').
                                        joins(:raw_definition).
                                        where(raw_definitions: {word_id: @raw_synonyms.map(&:id)}).
                                        where(deleted_at:nil).
                                        group_by(&:word_id)

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
    @words = @synset.words.map(&:word)

    render :create_synset
  end

  def set_default_definition
    @synset = Synset.find(params[:synset_id])
    @definition = Definition.find(params[:definition_id])
    @synset.update_with_tracking {|s| s.default_definition = @definition }

    show_synset
  end

  def set_default_synset_word
    @synset = Synset.find(params[:synset_id])
    @synset_word = SynsetWord.find(params[:synset_word_id])
    @synset.update_with_tracking {|s| s.default_synset_word = @synset_word }

    show_synset
  end

  def edit_marks
    synset_word = SynsetWord.find(params[:synset_word_id])
    synset_word.update_with_tracking(marks_ids: Array.wrap(params[:marks]))

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
    @new_synset = @synset.dup

    @new_synset.definitions_ids = (params[:definitions_ids] || []).map(&:to_i)
    @new_synset.words_ids = []

    # retrieve existent word associations
    words_mapping = @synset.words.inject({}) do |h, sw|
      h[sw.word_id] = sw; h
    end

    # the word 'lexeme' is used to distinguish `synset_word` from `word`
    lexemes_ids = (params[:lexemes_ids] || []).map(&:to_i)

    lexemes_mapping = Word.find(lexemes_ids).inject({}) do |h, w|
      h[w.id] = w; h
    end

    lexemes_ids.each do |word_id|
      synset_word = if words_mapping[word_id]
        SynsetWord.find(words_mapping[word_id].id)
      else
        synset_word = SynsetWord.new(word: lexemes_mapping[word_id])
        synset_word.author = current_user
        synset_word
      end

      definitions = @new_synset.definitions_ids - @synset.definitions_ids

      unless definitions.empty?
        synset_words = RawSynsetWord.find_by_content(definitions, word_id)
        samples = Sample.find_by_raw_synset_words(synset_words.map(&:id))
        synset_word.samples_ids = samples.map(&:id)
      end

      synset_word.save!

      @new_synset.words_ids += [synset_word.id]
    end

    @synset.update_from(@new_synset, :save!)
    @synset.reload

    render 'create_synset'
  end

  protected

  def build_samples
    definition_ids = @definitions.map(&:id) + @synonyms_definitions.values.flatten.map(&:id)

    @samples = Sample.select('current_samples.*, definition_id').
                      joins(:raw_example => :raw_definition).
                      where(raw_definitions: {definition_id: definition_ids}).
                      group_by(&:definition_id)

    @samples.inject({}) do |hash, (definition_id, samples)|
      hash[definition_id] = samples.map! {|sample| '%s (%s)' % [sample.text, sample.source || 'н/д'] }

      hash
    end
  end

  def words_to_definitions
    @words_to_definitions ||= @word.raw_synset_words.inject({}) do |h, rsw|
      rsw.synsets.map(&:definitions_ids).flatten.each { |id| h[id] = Array.wrap(h[id]) << rsw }

      h
    end
  end
end
