class SynsetsController < ApplicationController
  before_filter :find_synset, :only => [:show, :destroy, :edit, :approve, :set_domain]
  before_filter :find_word, :only => :search
  before_filter :set_top_bar_synset, :only => :show
  before_filter :allow_destroy?, :only => [:destroy, :merge]
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

    respond_to do |format|
      format.html
      format.xml { render xml: @synset }
      format.json
    end
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

  def merge
    @acceptor = Synset.where(deleted_at: nil).find(params[:acceptor_synset_id])
    @synset = Synset.where(deleted_at: nil).find(params[:synset_id])

    intersection = @acceptor.words.map do |asw|
      [asw, @synset.words.find { |sw| sw.word_id == asw.word_id }]
    end

    intersection.each do |acceptor_word, synset_word|
      next unless synset_word

      acceptor_word.update_with_tracking do |acceptor_word|
        acceptor_word.definitions_ids |= synset_word.definitions_ids
        acceptor_word.examples_ids |= synset_word.examples_ids
        acceptor_word.marks_ids |= synset_word.marks_ids
      end

      synset_word.destroy
      @synset.words_ids = @synset.words_ids - [synset_word.id]
    end

    @acceptor.update_with_tracking do |acceptor|
      acceptor.words_ids |= @synset.words_ids
    end

    @synset.destroy

    respond_to do |format|
      format.html { redirect_to synset_url(@acceptor) }
      format.xml  { render xml: @acceptor }
      format.json { render json: @acceptor }
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
    cookies['wordId']   = synset_word.word_id if synset_word.present?
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
    @synset = Synset.where(deleted_at: nil).find(params[:id])
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
