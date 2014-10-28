class CreateRawSubsumptions < ActiveRecord::Migration
  def change
    create_table :raw_subsumptions do |t|
      t.integer :hypernym_id, null: false
      t.integer :hyponym_id, null: false
      t.text :source
      t.timestamps
    end

    change_table :raw_subsumptions do |t|
      t.index :hypernym_id
      t.index :hyponym_id
      t.index [:hypernym_id, :hyponym_id, :source], unique: true
      t.index :created_at
      t.index :updated_at

      t.foreign_key :current_words,
        :column => :hypernym_id,
        :dependent => :delete

      t.foreign_key :current_words,
        :column => :hyponym_id,
        :dependent => :delete
    end
  end
end
