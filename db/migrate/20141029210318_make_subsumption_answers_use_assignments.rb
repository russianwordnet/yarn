class MakeSubsumptionAnswersUseAssignments < ActiveRecord::Migration
  def up
    change_table :subsumption_answers do |t|
      t.remove_index :raw_subsumption_id
      t.remove_index %i(raw_subsumption_id user_id)
      t.remove_foreign_key :raw_subsumptions

      t.rename :raw_subsumption_id, :assignment_id
      t.index :assignment_id
      t.index %i(assignment_id user_id)
      t.foreign_key :subsumption_assignments,
        :column => :assignment_id,
        :dependent => :delete
    end
  end

  def down
    change_table :subsumption_answers do |t|
      t.remove_index :assignment_id
      t.remove_index %i(assignment_id user_id)
      t.remove_foreign_key :subsumption_assignments

      t.rename :assignment_id, :raw_subsumption_id
      t.index :assignment_id
      t.index %i(raw_subsumption_id user_id)
      t.foreign_key :raw_subsumptions,
        :column => :raw_subsumption_id,
        :dependent => :delete
    end
  end
end
