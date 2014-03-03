class CreateCurrentSynsetWordsDefinitions < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE OR REPLACE VIEW current_synset_words_definitions AS 
       SELECT current_synset_words.id AS synset_word_id,
          unnest(current_synset_words.definitions_ids) AS definition_id
         FROM current_synset_words;
    SQL
  end

  def down
    execute 'DROP VIEW current_synset_words_definitions;'
  end
end
