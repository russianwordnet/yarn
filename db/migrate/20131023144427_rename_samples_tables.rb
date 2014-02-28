class RenameSamplesTables < ActiveRecord::Migration
  def up
    %w(current_samples raw_samples).each do |table_name|
      ActiveRecord::Base.connection.indexes(table_name).each do |index|
        remove_index table_name.to_sym, name: index.name
      end

      ActiveRecord::Base.connection.foreign_keys(table_name).each do |fk|
        remove_foreign_key table_name.to_sym, name: fk.options[:name]
      end
    end

    remove_foreign_key :samples, name: 'samples_sample_id_fk'
    drop_table :current_samples
    rename_table :raw_samples, :current_samples
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'No.'
  end
end
