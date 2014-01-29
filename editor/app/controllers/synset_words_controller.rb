class SynsetWordsController < ApplicationController
  before_filter :find_synset
  before_filter :find_synset_word
  before_filter :set_top_bar_word, :only => :show
  before_filter :set_top_bar_synset, :only => :show

  def show
    respond_to do |format|
      format.html
      format.xml { render xml: @synset_word }
      format.json { render json: @synset_word }
    end
  end

  def edit
    cookies['wordId']   = @synset_word.word_id
    cookies['synsetId'] = @synset.id if @synset.present?

    redirect_to editor_url
  end

  protected
  def find_synset
    return unless params[:synset_id].present?
    @synset = Synset.find(params[:synset_id])
  end

  def find_synset_word
    @synset_word = SynsetWord.find(params[:id])
  end

  def set_top_bar_word
    self.top_bar_word = @synset_word.word
  end

  def set_top_bar_synset
    self.top_bar_synset = @synset
  end
end
