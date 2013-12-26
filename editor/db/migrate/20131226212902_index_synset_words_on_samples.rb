class IndexSynsetWordsOnSamples < ActiveRecord::Migration
  def up
    execute 'CREATE INDEX index_current_synset_words_on_samples_ids ON current_synset_words USING gin (samples_ids);'
    execute 'CREATE INDEX index_synset_words_on_samples_ids ON synset_words USING gin (samples_ids);'
  end

  def down
    remove_index :current_synset_words, :name => :index_current_synset_words_on_samples_ids
    remove_index :synset_words, :name => :index_synset_words_on_samples_ids
  end
end
