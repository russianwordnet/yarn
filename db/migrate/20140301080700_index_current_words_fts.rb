class IndexCurrentWordsFts < ActiveRecord::Migration
  def up
    execute "CREATE INDEX index_current_words_on_word_fts ON current_words USING gin(to_tsvector('russian', word));"
  end

  def down
    remove_index :current_words, :name => :index_current_words_on_word_fts
  end
end
