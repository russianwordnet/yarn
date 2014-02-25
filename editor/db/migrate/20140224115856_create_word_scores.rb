class CreateWordScores < ActiveRecord::Migration
  def up
    # it hangs when the multi-line approach is used :(
    execute \
      'CREATE MATERIALIZED VIEW word_scores AS ' \
        'SELECT current_words.id AS word_id, ' \
          'yarn_word_score(current_words.id) AS score, ' \
          'LOCALTIMESTAMP AS created_at ' \
        'FROM current_words ' \
      'WITH DATA;'

    add_index :word_scores, :word_id
  end

  def down
    execute 'DROP MATERIALIZED VIEW word_scores;'
  end
end
