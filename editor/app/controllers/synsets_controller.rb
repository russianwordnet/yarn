class SynsetsController < ApplicationController
  before_filter :find_synset, :only => :show
  before_filter :set_top_bar_synset, :only => :show

  def index
    @synsets = Synset.order('updated_at DESC').page params[:page]

    respond_to do |format|
      format.html
      format.xml { render xml: @synsets }
      format.json { render json: @synsets }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render xml: @synset }
      format.json { render json: @synset }
    end
  end

  protected
  def find_synset
    @synset = Synset.find(params[:id])
  end

  def set_top_bar_synset
    self.top_bar_synset = @synset
  end
end
