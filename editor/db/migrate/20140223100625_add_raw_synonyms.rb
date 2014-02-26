class AddRawSynonyms < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE OR REPLACE VIEW raw_synonyms AS 
               SELECT raw_synonymies.id as raw_synonymy_id,
                  raw_synonymies.word1_id,
                  raw_synonymies.word2_id
                 FROM raw_synonymies
      UNION ALL
               SELECT raw_synonymies.id as raw_synonymy_id,
                  raw_synonymies.word2_id AS word1_id,
                  raw_synonymies.word1_id AS word2_id
                 FROM raw_synonymies;
    SQL
  end

  def down
    execute 'DROP VIEW IF EXISTS raw_synonyms;'
  end
end
