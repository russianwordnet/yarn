class UpdateSampleIdReferencesToExampleId < ActiveRecord::Migration
  def change
    rename_column :current_synset_words, :samples_ids, :examples_ids
    rename_column :synset_words, :samples_ids, :examples_ids
    rename_column :raw_synset_words, :samples_ids, :examples_ids
    rename_column :raw_examples, :sample_id, :example_id
  end
end
