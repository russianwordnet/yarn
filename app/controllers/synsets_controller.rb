class SynsetsController < ApplicationController
  before_filter :find_synset, :only => [:show, :destroy, :edit, :approve, :set_domain]
  before_filter :find_word, :only => :search
  before_filter :set_top_bar_synset, :only => :show
  before_filter :allow_destroy?, :only => :destroy
  before_filter :allow_approve?, :only => :approve

  respond_to :html, :json

  def index
    @synsets = Synset.order('updated_at DESC').page params[:page]

    respond_to do |format|
      format.html
      format.xml { render xml: @synsets }
      format.json { render json: @synsets }
    end
  end

  def show
    @definitions = @synset.definitions
    @synset_words = @synset.words_with_default_first
    @lexemes = @synset.lexemes.to_a
  end

  def search
    @synsets = @word.synset_words.map(&:synsets).flatten.uniq

    respond_to do |format|
      format.xml { render xml: @synsets }
      format.json { render json: @synsets }
    end
  end

  def destroy
    @synset.destroy

    respond_to do |format|
      format.html { redirect_to action: :index }
      format.json { head :no_content }
    end
  end

  def approve
    @synset.approver = current_user
    @synset.approved_at = DateTime.now
    @synset.save!

    respond_to do |format|
      format.html { redirect_to action: :index }
      format.json { head :no_content }
    end
  end

  def edit
    synset_word = @synset.default_synset_word || @synset.words.first
    cookies['wordId']   = synset_word.word_id
    cookies['synsetId'] = @synset.id

    redirect_to editor_url
  end

  def set_domain
    @domain = Domain.find(params[:domain])
    @synset.domain = @domain

    respond_to do |format|
      format.html { redirect_to action: :index }
      format.json { head :no_content }
    end
  end

  protected
  def find_synset
    @synset = Synset.find(params[:id])
  end

  def find_word
    @word = Word.find_by_word(params[:word])
  end

  def set_top_bar_synset
    self.top_bar_synset = @synset
  end

  def allow_destroy?
    return false unless user_signed_in?

    head :forbidden unless @synset.allow_destroy_by?(current_user)
  end

  def allow_approve?
    head :forbidden unless current_user.try(:admin?)
  end
end
