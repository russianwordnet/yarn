class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :type, null: false
      t.integer :author_id
      t.integer :approver_id
      t.timestamp :approved_at
      t.timestamps
    end

    change_table :entries do |t|
      t.index :type
      t.index :author_id
      t.index :approver_id

      t.foreign_key :users, :column => :author_id, :dependent => :delete
      t.foreign_key :users, :column => :approver_id, :dependent => :delete
    end
  end
end
