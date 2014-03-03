class AddDefinitionsIdsToSynsetWords < ActiveRecord::Migration
  def change
    change_table :current_synset_words do |t|
      t.integer :definitions_ids, array: true, default: []
    end

    change_table :synset_words do |t|
      t.integer :definitions_ids, array: true, default: []
    end
  end
end
