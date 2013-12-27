class IndexRawSynsetsOnWordsAndDefinitions < ActiveRecord::Migration
  def up
    remove_index :raw_synsets, :name => :index_raw_synsets_on_words_ids
    remove_index :raw_synsets, :name => :index_raw_synsets_on_definitions_ids
    execute 'CREATE INDEX index_raw_synsets_on_words_ids ON raw_synsets USING gin (words_ids);'
    execute 'CREATE INDEX index_raw_synsets_on_definitions_ids ON raw_synsets USING gin (definitions_ids);'
  end

  def down
    remove_index :raw_synsets, :name => :index_raw_synsets_on_words_ids
    remove_index :raw_synsets, :name => :index_raw_synsets_on_definitions_ids
  end
end
