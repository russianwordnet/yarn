class SimplifyWordsScores < ActiveRecord::Migration
  def up
    execute 'DROP MATERIALIZED VIEW IF EXISTS current_words_scores;'

    execute <<-SQL
      CREATE MATERIALIZED VIEW current_words_scores AS 
       SELECT current_words.id AS word_id,
          log(2, (1 + current_words.frequency)::numeric /
                 (1 + (SELECT count(*) FROM current_words current_words_local
                       JOIN raw_synonyms ON raw_synonyms.word2_id = current_words_local.id
                       WHERE raw_synonyms.word1_id = current_words.id
                       AND current_words_local.deleted_at IS NULL)::numeric)) AS score,
          'now'::text::timestamp without time zone AS created_at
         FROM current_words
      WITH DATA;
    SQL
  end

  def down
    require_relative './20141019192909_screw_yarn_word_score.rb'
    ScrewYarnWordScore.new.up
  end
end
