class CreateSubsumptionAssignments < ActiveRecord::Migration
  def change
    create_table :subsumption_assignments do |t|
      t.integer :raw_subsumption_id, null: false
      t.integer :hypernym_synset_id, null: false
      t.integer :hyponym_synset_id, null: false
      t.timestamps
    end

    change_table :subsumption_assignments do |t|
      t.index :raw_subsumption_id
      t.index :hypernym_synset_id
      t.index :hyponym_synset_id
      t.index [:hypernym_synset_id, :hyponym_synset_id], unique: true, name: 'index_subsumption_assignments_on_synset_ids'
      t.index :created_at
      t.index :updated_at

      t.foreign_key :raw_subsumptions,
        :column => :raw_subsumption_id,
        :dependent => :delete

      t.foreign_key :current_synsets,
        :column => :hypernym_synset_id,
        :dependent => :delete

      t.foreign_key :current_synsets,
        :column => :hyponym_synset_id,
        :dependent => :delete
    end
  end
end
