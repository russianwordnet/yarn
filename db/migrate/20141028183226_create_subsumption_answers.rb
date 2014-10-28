class CreateSubsumptionAnswers < ActiveRecord::Migration
  def change
    create_table :subsumption_answers do |t|
      t.integer :raw_subsumption_id, null: false
      t.integer :user_id, null: false
      t.text :answer
      t.timestamps
    end

    change_table :subsumption_answers do |t|
      t.index :raw_subsumption_id
      t.index :user_id
      t.index [:raw_subsumption_id, :user_id], unique: true
      t.index :answer
      t.index :created_at
      t.index :updated_at

      t.foreign_key :raw_subsumptions,
        :column => :raw_subsumption_id,
        :dependent => :delete

      t.foreign_key :users,
        :column => :user_id,
        :dependent => :delete
    end
  end
end
