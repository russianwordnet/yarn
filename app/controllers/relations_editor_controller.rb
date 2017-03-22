class RelationsEditorController < ApplicationController
  before_filter :authenticate_user!

  def show
  end

  def save
    synset_relation = SynsetRelation.find_or_initialize_by(
      params.require(:relation).permit(:synset1_id, :synset2_id)
    )

    synset_relation.update_with_tracking(relation_params)
    render json: {}
  end

  def relations
    word1 = Word.find(params.require(:word1))
    word2 = Word.find(params.require(:word2))

    synsets = word1.synsets.pluck(:id) + word2.synsets.pluck(:id)

    render json: SynsetRelation
      .where(synset1_id: synsets, synset2_id: synsets)
  end

  private

  def relation_params
    params.require(:relation).permit(:relation_type).merge(author: current_user)
  end
end
