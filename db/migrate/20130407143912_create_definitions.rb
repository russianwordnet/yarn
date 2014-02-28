class CreateDefinitions < ActiveRecord::Migration
  def change
    create_table :definitions do |t|
      t.integer :author_id
      t.integer :approver_id
      t.timestamp :approved_at
      t.integer :revision, null: false, default: 1

      t.text :text, null: false
      t.string :source
      t.string :uri

      t.integer :definition_id, null: false
      t.timestamp :created_at
      t.timestamp :deleted_at
    end

    change_table :definitions do |t|
      t.index :author_id
      t.index :approver_id
      t.index :approved_at
      t.index :revision

      t.index :source
      t.index :uri

      t.index :definition_id
      t.index :created_at
      t.index :deleted_at

      t.foreign_key :users,
        :column => :author_id,
        :dependent => :delete
      t.foreign_key :users,
        :column => :approver_id,
        :dependent => :delete
      t.foreign_key :current_definitions,
        :column => :definition_id,
        :dependent => :delete
    end
  end
end
