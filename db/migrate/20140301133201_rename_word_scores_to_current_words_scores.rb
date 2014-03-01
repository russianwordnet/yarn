class RenameWordScoresToCurrentWordsScores < ActiveRecord::Migration
  def up
    execute 'ALTER MATERIALIZED VIEW word_scores RENAME TO current_words_scores;'
  end

  def down
    execute 'ALTER MATERIALIZED VIEW current_words_scores RENAME TO word_scores;'
  end
end
