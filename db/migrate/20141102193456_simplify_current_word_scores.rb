class SimplifyCurrentWordScores < ActiveRecord::Migration
  def up
    execute 'DROP MATERIALIZED VIEW IF EXISTS current_words_scores;'
    execute <<-SQL
    CREATE MATERIALIZED VIEW current_words_scores AS 
    SELECT current_words.id AS word_id,
       log(10, (1 + current_words.frequency)::numeric) *
             (1 + (SELECT count(*) FROM current_words current_words_local
                   JOIN raw_synonyms ON raw_synonyms.word2_id = current_words_local.id
                   WHERE raw_synonyms.word1_id = current_words.id
                   AND current_words_local.deleted_at IS NULL)::double precision) /
             (1 + (SELECT COALESCE(sum(array_length(current_synsets.words_ids, 1)), 0) FROM current_synsets
                   JOIN current_synset_words ON current_synsets.words_ids @> ARRAY[current_synset_words.id]
                   WHERE current_synset_words.word_id = current_words.id
                   AND current_synset_words.deleted_at IS NULL
                   AND current_synsets.deleted_at IS NULL
                   AND array_length(current_synsets.words_ids, 1) > 1)::double precision) AS score,
       localtimestamp AS created_at
      FROM current_words
      WITH DATA;
    SQL
  end

  def down
  end
end
