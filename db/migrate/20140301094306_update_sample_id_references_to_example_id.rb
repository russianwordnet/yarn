class UpdateSampleIdReferencesToExampleId < ActiveRecord::Migration
  def up
    rename_column :current_synset_words, :samples_ids, :examples_ids
    remove_index :current_synset_words, :samples_ids
    execute 'CREATE INDEX index_current_synset_words_on_examples_ids ON current_synset_words USING gin (examples_ids);'

    rename_column :synset_words, :samples_ids, :examples_ids
    remove_index :synset_words, :samples_ids
    execute 'CREATE INDEX index_synset_words_on_examples_ids ON synset_words USING gin (examples_ids);'

    rename_column :raw_synset_words, :samples_ids, :examples_ids
    remove_index :raw_synset_words, :samples_ids
    execute 'CREATE INDEX index_raw_synset_words_on_examples_ids ON raw_synset_words USING gin (examples_ids);'

    rename_column :raw_examples, :sample_id, :example_id
    remove_index :raw_examples, :sample_id
    add_index :raw_examples, :example_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'No.'
  end
end
