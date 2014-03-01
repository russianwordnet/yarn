class CreateCurrentSynsetWordsExamples < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE OR REPLACE VIEW current_synset_words_examples AS 
       SELECT current_synset_words.id AS synset_word_id,
          unnest(current_synset_words.examples_ids) AS example_id
         FROM current_synset_words;
    SQL
  end

  def down
    execute 'DROP VIEW current_synset_words_examples;'
  end
end
