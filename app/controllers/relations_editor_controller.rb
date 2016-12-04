class RelationsEditorController < ApplicationController
  before_filter :authenticate_user!

  def show
  end

  def save
    synset_relation = SynsetRelation.new

    synset_relation.update_with_tracking(relation_params)
    render json: {}
  end

  private

  def relation_params
    params.require(:relation).permit(
      :synset1_id, :synset2_id, :relation_type
    ).merge(author: current_user)
  end
end
