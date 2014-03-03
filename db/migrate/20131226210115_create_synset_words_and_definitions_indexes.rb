class CreateSynsetWordsAndDefinitionsIndexes < ActiveRecord::Migration
  def up
    remove_index :current_synsets, :name => :index_current_synsets_on_definitions_ids
    remove_index :synsets, :name => :index_synsets_on_definitions_ids
    remove_index :current_synsets, :name => :index_current_synsets_on_words_ids
    remove_index :synsets, :name => :index_synsets_on_words_ids

    execute 'CREATE INDEX index_current_synsets_on_words_ids ON current_synsets USING gin (words_ids);'
    execute 'CREATE INDEX index_synsets_on_words_ids ON synsets USING gin (words_ids);'
    execute 'CREATE INDEX index_current_synsets_on_definitions_ids ON current_synsets USING gin (definitions_ids);'
    execute 'CREATE INDEX index_synsets_on_definitions_ids ON synsets USING gin (definitions_ids);'
  end

  def down
    remove_index :current_synsets, :name => :index_current_synsets_on_definitions_ids
    remove_index :synsets, :name => :index_synsets_on_definitions_ids
    remove_index :current_synsets, :name => :index_current_synsets_on_words_ids
    remove_index :synsets, :name => :index_synsets_on_words_ids
  end
end
