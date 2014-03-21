class IndexSynsetWordsOnDefinitions < ActiveRecord::Migration
  def up
    execute 'CREATE INDEX index_current_synset_words_on_definitions_ids ON current_synset_words USING gin (definitions_ids);'
    execute 'CREATE INDEX index_synset_words_on_definitions_ids ON synset_words USING gin (definitions_ids);'
  end

  def down
    remove_index :current_synset_words, :name => :index_current_synset_words_on_definitions_ids
    remove_index :synset_words, :name => :index_synset_words_on_definitions_ids
  end
end
