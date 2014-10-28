class CreateRawSubsumptionsScores < ActiveRecord::Migration
  def up
    execute <<-SQL
CREATE OR REPLACE VIEW raw_subsumptions_scores AS
 SELECT raw_subsumptions.id AS raw_subsumption_id,
    current_hypernyms.frequency + current_hyponyms.frequency AS score
   FROM raw_subsumptions
     JOIN current_words current_hypernyms ON current_hypernyms.id = raw_subsumptions.hypernym_id
     JOIN current_words current_hyponyms ON current_hyponyms.id = raw_subsumptions.hyponym_id
  WHERE current_hypernyms.deleted_at IS NULL AND current_hyponyms.deleted_at IS NULL;
    SQL
  end

  def down
    execute 'DROP VIEW IF EXISTS raw_subsumptions_scores;'
  end
end
