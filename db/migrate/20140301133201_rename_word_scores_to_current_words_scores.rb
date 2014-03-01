class RenameWordScoresToCurrentWordsScores < ActiveRecord::Migration
  def up
    remove_index :word_scores, :word_id if index_exists? :word_scores, :word_id
    remove_index :word_scores, :score if index_exists? :word_scores, :score

    execute 'ALTER MATERIALIZED VIEW word_scores RENAME TO current_words_scores;'

    add_index :current_words_scores, :word_id, unique: true
    add_index :current_words_scores, :score
  end

  def down
    remove_index :current_words_scores, :word_id
    remove_index :current_words_scores, :score

    execute 'ALTER MATERIALIZED VIEW current_words_scores RENAME TO word_scores;'

    add_index :word_scores, :word_id, unique: true
    add_index :word_scores, :score
  end
end
