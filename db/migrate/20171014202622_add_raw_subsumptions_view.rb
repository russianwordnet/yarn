class AddRawSubsumptionsView < ActiveRecord::Migration
  def up
    execute 'DROP VIEW IF EXISTS raw_subsumptions;'
    execute "CREATE VIEW raw_subsumptions AS SELECT *, upper_id as hypernym_id, lower_id as hyponym_id FROM raw_relations WHERE type = 'hypernymy';"
  end

  def down
    execute 'DROP VIEW IF EXISTS raw_subsumptions;'
  end
end
