class RawSynsetWordsController < ApplicationController
  before_filter :find_raw_synset
  before_filter :find_raw_synset_word

  def show
    respond_to do |format|
      format.html
      format.xml { render xml: @raw_synset_word }
      format.json { render json: @raw_synset_word }
    end
  end

  protected
  def find_raw_synset
    @raw_synset = RawSynset.find(params[:raw_synset_id])
  end

  def find_raw_synset_word
    @raw_synset_word = RawSynsetWord.find(params[:id])
  end
end
