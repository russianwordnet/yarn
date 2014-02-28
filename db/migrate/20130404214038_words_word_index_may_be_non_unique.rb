class WordsWordIndexMayBeNonUnique < ActiveRecord::Migration
  def change
    change_table :words do |t|
      t.remove_index name: 'index_entries_on_word'
      t.index :word
    end
  end
end
