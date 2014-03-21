class RawSynsetsController < ApplicationController
  before_filter :find_raw_synset, :only => :show
  before_filter :find_word, :only => :search

  def index
    @raw_synsets = RawSynset.order('updated_at DESC').page params[:page]

    respond_to do |format|
      format.html
      format.xml { render xml: @raw_synsets }
      format.json { render json: @raw_synsets }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render xml: @raw_synset }
      format.json { render json: @raw_synset }
    end
  end

  def search
    @raw_synsets = @word.raw_synset_words.map(&:synsets).flatten.uniq

    respond_to do |format|
      format.xml { render xml: @raw_synsets }
      format.json { render json: @raw_synsets }
    end
  end

  protected
  def find_raw_synset
    @raw_synset = RawSynset.find(params[:id])
  end

  def find_word
    @word = Word.find_by_word(params[:word])
  end
end
