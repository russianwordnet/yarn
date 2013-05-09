class SynsetWordsController < ApplicationController
  before_filter :find_synset
  before_filter :find_synset_word, :only => :show

  def show
  end

  protected
  def find_synset
    @synset = Synset.find(params[:synset_id])
  end

  def find_synset_word
    @synset_word = SynsetWord.find(params[:id])
  end
end
