class SamplesIdsIndicesAreWorthlessRightNow < ActiveRecord::Migration
  def change
    change_table :current_synset_words do |t|
      t.remove_index :samples_ids
    end

    change_table :synset_words do |t|
      t.remove_index :samples_ids
    end
  end
end
