class CreateCurrentSynsetsSynonyms < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE OR REPLACE VIEW current_synsets_synonyms AS 
       SELECT current_synsets.id AS synset_id,
          unnest(current_synsets.words_ids) AS synset_word_id
         FROM current_synsets;
    SQL
  end

  def down
    execute 'DROP VIEW current_synsets_synonyms;'
  end
end
