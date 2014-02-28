class IndexCurrentWordsTrgm < ActiveRecord::Migration
  def up
    execute 'CREATE INDEX index_current_words_on_word_trgm ON current_words USING gin (word gin_trgm_ops);'
  end

  def down
    remove_index :current_words, :name => :index_current_words_on_word_trgm
  end
end
