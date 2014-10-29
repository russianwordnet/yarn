class ExcludeSourceFromTheRawSubsumptionsIndex < ActiveRecord::Migration
  def up
    change_table :raw_subsumptions do |t|
      t.remove_index %i(hypernym_id hyponym_id source)
      t.index %i(hypernym_id hyponym_id), unique: true
    end
  end

  def down
    change_table :raw_subsumptions do |t|
      t.remove_index %i(hypernym_id hyponym_id)
      t.index %i(hypernym_id hyponym_id source), unique: true
    end
  end
end
