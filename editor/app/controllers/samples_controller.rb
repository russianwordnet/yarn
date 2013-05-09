class SamplesController < ApplicationController
  before_filter :find_synset
  before_filter :find_synset_word
  before_filter :find_sample, :only => :show

  def show
  end

  protected
  def find_synset
    @synset = Synset.find(params[:synset_id])
  end

  def find_synset_word
    @synset_word = SynsetWord.find(params[:word_id])
  end

  def find_sample
    @sample = Sample.find(params[:id])
  end
end
