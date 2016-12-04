class AllowBlankApproverInSynsetRelations < ActiveRecord::Migration
  def change
    change_column :current_synset_relations, :approver_id, :integer, null: true
    change_column :synset_relations, :approver_id, :integer, null: true
  end
end
