class RemoveUnneededIndexes < ActiveRecord::Migration
  def change
    remove_index :badges_sashes, name: "index_badges_sashes_on_badge_id"
    remove_index :raw_subsumptions, name: "index_raw_subsumptions_on_hypernym_id"
    remove_index :raw_synonymies, name: "index_raw_synonymies_on_word1_id"
    remove_index :subsumption_answers, name: "index_subsumption_answers_on_assignment_id"
    remove_index :subsumption_assignments, name: "index_subsumption_assignments_on_hypernym_synset_id"
  end
end
