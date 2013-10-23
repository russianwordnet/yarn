class AddSamplesIndex < ActiveRecord::Migration
  def up
    change_table :samples do |t|
      t.foreign_key :current_samples,
        :column => :sample_id,
        :dependent => :delete
    end

    change_table :current_samples do |t|
      t.integer :approver_id
      t.timestamp :approved_at
      t.integer :revision, null: false, default: 1

      t.remove :created_at
      t.timestamp :deleted_at
    end

    change_table :current_samples do |t|
      t.index :author_id
      t.index :approver_id
      t.index :approved_at
      t.index :revision

      t.index :source
      t.index :uri

      t.index :updated_at
      t.index :deleted_at

      t.foreign_key :users,
        :column => :approver_id,
        :dependent => :delete

      t.foreign_key :users,
        :column => :author_id,
        :dependent => :delete
    end

    execute 'ALTER INDEX raw_samples_pkey RENAME TO current_samples_pkey'
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'No.'
  end
end
