class BringTheExamplesIndexesBackHome < ActiveRecord::Migration
  def up
    execute 'ALTER INDEX current_samples_pkey RENAME TO current_examples_pkey'
    execute 'ALTER INDEX samples_pkey RENAME TO examples_pkey'

    rename_column :examples, :sample_id, :example_id
    add_index :examples, :example_id
    add_foreign_key :examples, :current_examples,
      :column => :example_id,
      :dependent => :delete

    %w(current_examples examples).each do |table_name|
      add_index table_name, :author_id
      add_index table_name, :approver_id
      add_index table_name, :approved_at
      add_index table_name, :revision

      add_index table_name, :source
      add_index table_name, :uri

      add_index table_name, :deleted_at

      add_foreign_key table_name, :users,
        :column => :approver_id,
        :dependent => :delete

      add_foreign_key table_name, :users,
        :column => :author_id,
        :dependent => :delete
    end

    add_index :current_examples, :updated_at
    add_index :examples, :created_at
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'No.'
  end
end
