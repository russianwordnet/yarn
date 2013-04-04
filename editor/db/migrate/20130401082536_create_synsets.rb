class CreateSynsets < ActiveRecord::Migration
  def change
    create_table :synsets do |t|
      t.integer :author_id
      t.integer :approver_id
      t.timestamp :approved_at
      t.integer :revision, null: false, default: 1

      t.text :words
      t.text :definitions
      t.text :pwns

      t.timestamp :deleted_at
    end

    change_table :synsets do |t|
      t.index :revision
      t.index :deleted_at
      t.index :author_id
      t.index :approver_id
      t.index :approved_at

      t.foreign_key :users, :column => :author_id, :dependent => :delete
      t.foreign_key :users, :column => :approver_id, :dependent => :delete
    end
  end
end
