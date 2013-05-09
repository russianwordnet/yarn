class SynsetsController < ApplicationController
  before_filter :find_synset, :only => :show

  def index
    @synsets = Synset.order('updated_at DESC').page params[:page]
  end

  def show
  end

  protected
  def find_synset
    @synset = Synset.find(params[:id])
  end
end
