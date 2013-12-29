class SynsetsController < ApplicationController
  before_filter :find_synset, :only => [:show, :destroy]
  before_filter :find_word, :only => :search
  before_filter :set_top_bar_synset, :only => :show
  before_filter :allow_destroy?, :only => :destroy

  helper_method :allow_edit?

  respond_to :html, :json

  def index
    @synsets = Synset.where('author_id <> ?', 1).
      order('updated_at DESC').page params[:page]

    respond_to do |format|
      format.html
      format.xml { render xml: @synsets }
      format.json { render json: @synsets }
    end
  end

  def show
    @definitions = @synset.definitions
    @synset_words = @synset.words
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
    @synset.delete

    respond_to do |format|
      format.html { redirect_to action: :index }
      format.json { head :ok }
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

  def allow_edit?(synset)
    current_user.admin? || synset.author_id == current_user.id
  end

  def allow_destroy?
    head :forbidden unless allow_edit?(@synset)
  end
end
