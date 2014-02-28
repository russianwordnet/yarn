class DefinitionsController < ApplicationController
  before_filter :find_synset
  before_filter :find_definition, :only => :show
  before_filter :set_top_bar_synset

  def index
    @definitions = Definition.order('updated_at DESC').page params[:page]

    respond_to do |format|
      format.html
      format.xml { render xml: @definitions }
      format.json { render json: @definitions }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render xml: @definition }
      format.json { render json: @definition }
    end
  end

  protected
  def find_synset
    return unless params[:synset_id].present?
    @synset = Synset.find(params[:synset_id])
  end

  def find_definition
    @definition = Definition.find(params[:id])
  end

  def set_top_bar_synset
    self.top_bar_synset = @synset
  end
end
