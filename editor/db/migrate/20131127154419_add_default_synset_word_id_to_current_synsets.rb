class AddDefaultSynsetWordIdToCurrentSynsets < ActiveRecord::Migration
  def change
    change_table :current_synsets do |t|
      t.integer :default_synset_word_id
      t.index :default_synset_word_id
      t.foreign_key :current_synset_words,
        :column => :default_synset_word_id
    end
  end
end
