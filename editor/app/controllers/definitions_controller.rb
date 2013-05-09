class DefinitionsController < ApplicationController
  before_filter :find_synset
  before_filter :find_definition, :only => :show

  def show
  end

  protected
  def find_synset
    @synset = Synset.find(params[:synset_id])
  end

  def find_definition
    @definition = Definition.find(params[:id])
  end
end
