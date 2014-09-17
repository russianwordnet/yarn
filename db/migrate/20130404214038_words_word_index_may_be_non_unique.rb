class WordsWordIndexMayBeNonUnique < ActiveRecord::Migration
  def change
    change_table :words do |t|
      if index_exists?(:words, :word, name: 'index_entries_on_word')
        t.remove_index name: 'index_entries_on_word'
      end

      unless index_exists?(:words, :word, name: 'index_words_on_word')
        t.index :word
      end
    end
  end
end
