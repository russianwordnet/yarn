class CreateRelationAssignments < ActiveRecord::Migration
  def change
    create_table :relation_assignments do |t|
      t.belongs_to :user
      t.belongs_to :raw_relation

      t.timestamps
    end
  end
end
