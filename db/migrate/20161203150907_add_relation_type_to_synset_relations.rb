class AddRelationTypeToSynsetRelations < ActiveRecord::Migration
  def change
    add_column :synset_relations, :relation_type, :string
    add_column :current_synset_relations, :relation_type, :string
  end
end
