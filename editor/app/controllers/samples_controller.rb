class SamplesController < ApplicationController
  before_filter :find_synset
  before_filter :find_synset_word
  before_filter :find_sample, :only => :show
  before_filter :set_top_bar_word
  before_filter :set_top_bar_synset
  before_filter :set_top_bar_synset_word

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

  def set_top_bar_word
    self.top_bar_word = @synset_word.word
  end

  def set_top_bar_synset
    self.top_bar_synset = @synset
  end

  def set_top_bar_synset_word
    self.top_bar_synset_word = @synset_word
  end
end
