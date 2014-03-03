class CreateCurrentInterlinks < ActiveRecord::Migration
  def change
    create_table :current_interlinks do |t|
      t.integer :synset_id, null: false
      t.text :pwn, null: false
      t.integer :author_id, null: false
      t.integer :revision, default: 1, null: false
      t.integer :approver_id, null: false
      t.timestamp :approved_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end

    change_table :current_interlinks do |t|
      t.index :synset_id
      t.index :pwn
      t.index :author_id
      t.index :revision
      t.index :approver_id
      t.index :approved_at
      t.index :updated_at
      t.index :deleted_at

      t.foreign_key :current_synsets,
        :column => :synset_id,
        :dependent => :delete

      t.foreign_key :users,
        :column => :author_id,
        :dependent => :delete

      t.foreign_key :users,
        :column => :approver_id,
        :dependent => :delete
    end
  end
end
