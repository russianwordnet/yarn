class TrackDefaultValuesInSynsets < ActiveRecord::Migration
  def up
    add_column :synsets, :default_definition_id, :integer
    add_column :synsets, :default_synset_word_id, :integer
  end

  def down
    remove_column :synsets, :default_definition_id
    remove_column :synsets, :default_synset_word_id
  end
end
