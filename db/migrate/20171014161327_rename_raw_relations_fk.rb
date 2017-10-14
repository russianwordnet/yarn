class RenameRawRelationsFk < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE raw_relations RENAME CONSTRAINT "raw_subsumptions_hypernym_id_fk" TO "raw_relations_upper_id_fk";'
    execute 'ALTER TABLE raw_relations RENAME CONSTRAINT "raw_subsumptions_hyponym_id_fk" TO "raw_relations_lower_id_fk";'

    rename_column :subsumption_assignments, :raw_subsumption_id, :raw_relation_id
    execute 'ALTER TABLE subsumption_assignments RENAME CONSTRAINT "subsumption_assignments_raw_subsumption_id_fk" TO "subsumption_assignments_raw_relation_id_fk";'
  end

  def down
    execute 'ALTER TABLE raw_relations RENAME CONSTRAINT "raw_relations_upper_id_fk" TO "raw_subsumptions_hypernym_id_fk";'
    execute 'ALTER TABLE raw_relations RENAME CONSTRAINT "raw_relations_lower_id_fk" TO "raw_subsumptions_hyponym_id_fk";'

    rename_column :subsumption_assignments, :raw_relation_id, :raw_subsumption_id
    execute 'ALTER TABLE subsumption_assignments RENAME CONSTRAINT "subsumption_assignments_raw_relation_id_fk" TO "subsumption_assignments_raw_subsumption_id_fk";'
  end
end
