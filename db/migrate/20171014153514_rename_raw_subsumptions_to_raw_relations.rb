class RenameRawSubsumptionsToRawRelations < ActiveRecord::Migration
  def change
    rename_column :raw_subsumptions, :hypernym_id, :upper_id
    rename_column :raw_subsumptions, :hyponym_id,  :lower_id
    rename_index :raw_subsumptions, 'index_raw_subsumptions_on_created_at', 'index_raw_relations_on_created_at'
    rename_index :raw_subsumptions, 'index_raw_subsumptions_on_upper_id_and_lower_id', 'index_raw_relations_on_upper_id_and_lower_id'
    rename_index :raw_subsumptions, 'index_raw_subsumptions_on_lower_id', 'index_raw_relations_on_lower_id'
    rename_index :raw_subsumptions, 'index_raw_subsumptions_on_updated_at', 'index_raw_relations_on_updated_at'
    rename_table :raw_subsumptions, :raw_relations
  end
end
