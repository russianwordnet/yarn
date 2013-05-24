class DefinitionsController < ApplicationController
  before_filter :find_synset
  before_filter :find_definition, :only => :show
  before_filter :set_top_bar_synset

  def show
  end

  protected
  def find_synset
    @synset = Synset.find(params[:synset_id])
  end

  def find_definition
    @definition = Definition.find(params[:id])
  end

  def set_top_bar_synset
    self.top_bar_synset = @synset
  end
end
