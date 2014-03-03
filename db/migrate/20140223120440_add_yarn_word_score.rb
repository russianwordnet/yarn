class AddYarnWordScore < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION yarn_word_score(yarn_word_id integer)
        RETURNS double precision AS
      $BODY$
        SELECT
          log(10, (1 + current_words.frequency)::numeric) *
          (1 + (SELECT count(*) FROM current_words JOIN raw_synonyms ON raw_synonyms.word2_id = current_words.id WHERE raw_synonyms.word1_id = yarn_word_id AND current_words.deleted_at IS NULL)::double precision) /
          (1 + (SELECT COALESCE(sum(array_length(current_synsets.words_ids, 1)), 0) FROM current_synsets JOIN current_synset_words ON current_synsets.words_ids @> ARRAY[current_synset_words.id] WHERE current_synset_words.word_id = yarn_word_id AND current_synset_words.deleted_at IS NULL AND current_synsets.deleted_at IS NULL AND array_length(current_synsets.words_ids, 1) > 1)::double precision)
        FROM current_words
        WHERE id = yarn_word_id
      $BODY$
        LANGUAGE sql STABLE;
    SQL
  end

  def down
    execute 'DROP FUNCTION IF EXISTS yarn_word_score(integer);'
  end
end
