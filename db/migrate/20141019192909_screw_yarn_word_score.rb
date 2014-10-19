class ScrewYarnWordScore < ActiveRecord::Migration
  def up
    execute 'DROP MATERIALIZED VIEW IF EXISTS current_words_scores;'
    execute 'DROP FUNCTION IF EXISTS yarn_word_score(yarn_word_id integer);'
    puts 'This operation is quite long. Keep calm and carry on.'

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
                      AND array_length(current_synsets.words_ids, 1) > 1)::double precision) *
                (1 + (SELECT count(*) FROM current_definitions
                      JOIN raw_definitions ON raw_definitions.definition_id = current_definitions.id
                      JOIN current_words current_words_local ON current_words_local.id = raw_definitions.word_id
                      WHERE current_words_local.id = current_words.id
                      AND current_words_local.deleted_at IS NULL
                      AND current_definitions.deleted_at IS NULL)::double precision) /
                (1 + (SELECT count(*) FROM current_definitions
                      JOIN current_synset_words_definitions ON current_synset_words_definitions.definition_id = current_definitions.id
                      JOIN current_synset_words ON current_synset_words.id = current_synset_words_definitions.synset_word_id
                      JOIN current_words current_words_local ON current_words_local.id = current_synset_words.word_id
                      WHERE current_words_local.id = current_words.id
                      AND current_words_local.deleted_at IS NULL
                      AND current_synset_words.deleted_at IS NULL
                      AND current_definitions.deleted_at IS NULL)::double precision) AS score,
          'now'::text::timestamp without time zone AS created_at
         FROM current_words
      WITH DATA;
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
