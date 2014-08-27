# encoding: utf-8

class WordsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :search, :approved, :show, :history]
  before_filter :find_word, :except => [:index, :search, :approved, :new, :create]
  before_filter :set_top_bar_word, :except => [:index, :search, :approved]
  before_filter :prepare_revert, :only => :revert
  before_filter :track_word, :only => [:update, :revert]

  def index
    @words = Word.where(deleted_at: nil).
      order('frequency DESC').page params[:page]

    respond_to do |format|
      format.html
      format.xml { render xml: @words }
      format.json { render json: @words }
    end
  end

  def search
    return (redirect_to(words_url) and false) unless params[:q].present?

    @words = Word.search(params[:q]).
      where(deleted_at: nil).
      order(['rank DESC', 'frequency DESC', 'word']).
      page(params[:page])

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
    @word = Word.find(params[:id])
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
end
