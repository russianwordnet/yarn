# encoding: utf-8

class WordsController < ApplicationController
  before_filter :authenticate_user!, only: %i(new create update approve disapprove revert destroy)
  before_filter :find_word, :except => [:index, :search, :approved, :new, :create]
  before_filter :set_top_bar_word, :except => [:index, :search, :approved]
  before_filter :prepare_revert, :only => :revert
  before_filter :track_word, :only => [:update, :revert]

  def index
    @words = if params[:q].present?
      Word.search(params[:q]).
        order(['rank DESC', 'frequency DESC', 'word'])
    else
      Word.order('frequency DESC')
    end

    @words = @words.where(deleted_at: nil).page(params[:page]).per(limit)

    respond_to do |format|
      format.html
      format.xml { render xml: @words }
      format.json { render json: @words }
    end
  end

  def approved
    approver_id = Word.arel_table[:approver_id]
    approved_at = Word.arel_table[:approved_at]

    @words = Word.where(
      approver_id.not_eq(nil),
      approved_at.not_eq(nil)
    ).order(:word).page params[:page]

    respond_to do |format|
      format.html
      format.xml { render xml: @words }
      format.json { render json: @words }
    end
  end

  def new
    @word = Word.new
  end

  def create
    @word = Word.new(params[:word]) do |word|
      word.author = current_user
    end

    if @word.save
      flash[:notice] = 'Слово добавлено.'
      redirect_to word_url(@word)
    else
      flash[:alert] = 'Не получилось добавить слово.'
      render action: 'new'
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render xml: @word }
      format.json { render json: @word }
    end
  end

  def update
    params[:word].delete :approver_id
    params[:word].delete :approved_at

    if @word.update_from(@new_word)
      flash[:notice] = 'Слово обновлено.'
      redirect_to word_url(@word)
    else
      flash[:alert] = 'Не получилось обновить слово.'
      render action: 'edit'
    end
  end

  def synsets
    @synsets = @word.synsets.where(deleted_at: nil)

    respond_to do |format|
      format.xml { render xml: @synsets }
      format.json { render json: @synsets }
    end
  end

  def synonyms
    @synonyms = @word.synsets.includes(:lexemes).
      where(current_synsets: { deleted_at: nil },
            current_synset_words: { deleted_at: nil },
            current_words: { deleted_at: nil }).
      map(&:lexemes).flatten

    respond_to do |format|
      format.xml { render xml: @synonyms }
      format.json { render json: @synonyms }
    end
  end

  def raw_synonyms
    @synonyms = @word.raw_synonyms.where(deleted_at: nil)

    respond_to do |format|
      format.xml { render xml: @synonyms }
      format.json { render json: @synonyms }
    end
  end

  def definitions
    @definitions = @word.definitions.where(deleted_at: nil)

    respond_to do |format|
      format.xml { render xml: @definitions }
      format.json { render json: @definitions }
    end
  end

  def raw_definitions
    @definitions = @word.raw_definitions.includes(:definition).
      where(current_definitions: { deleted_at: nil }).
      map(&:definition)

    respond_to do |format|
      format.xml { render xml: @definitions }
      format.json { render json: @definitions }
    end
  end

  def examples
    @examples = @word.examples.where(deleted_at: nil)

    respond_to do |format|
      format.xml { render xml: @examples }
      format.json { render json: @examples }
    end
  end

  def raw_examples
    @examples = @word.raw_examples.includes(:example).
      where(current_examples: { deleted_at: nil }).
      map(&:example)

    respond_to do |format|
      format.xml { render xml: @examples }
      format.json { render json: @examples }
    end
  end

  def approve
    @word.approved_at = DateTime.now
    @word.approver = current_user

    if @word.save
      flash[:notice] = 'Версия была утверждена.'
    else
      flash[:alert] = 'Не удалось утвердить версию.'
    end

    redirect_to word_url(@word)
  end

  def disapprove
    @word.approved_at = @word.approver = nil

    if @word.save
      flash[:notice] = 'Утверждение версии снято.'
    else
      flash[:alert] = 'Не удалось снять утверждение версии.'
    end

    redirect_to word_url(@word)
  end

  def destroy
    if @word.destroy
      flash[:notice] = 'Слово удалено.'
    else
      flash[:alert] = 'Не удалось удалить слово.'
    end

    render json: []
  end

  def history
    @history = @word.old_words
  end

  def revert
    if @word.update_from(@new_word)
      flash[:notice] = 'Выполнен откат к предыдущей версии.'
    else
      flash[:alert] = 'Не получилось откатиться.'
    end

    redirect_to word_url(@word)
  end

  protected
  def find_word
    @word = Word.where(deleted_at: nil).find(params[:id])
  end

  def set_top_bar_word
    self.top_bar_word = @word
  end

  def prepare_revert
    word = OldWord.find_by_word_id_and_revision(@word, params[:revision])
    params[:word] = HashWithIndifferentAccess.new(word.attributes)
  end

  def track_word
    attributes = @word.attributes
    attributes.merge! params[:word]
    attributes['author_id'] = current_user.id
    @new_word = OpenStruct.new(attributes)
  end

  def limit
    params[:limit].presence
  end
end
