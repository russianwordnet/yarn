class InterlinksAreInterlanguageRelations < ActiveRecord::Migration
  def up
    %w(current_interlinks interlinks).each do |table_name|
      ActiveRecord::Base.connection.indexes(table_name).each do |index|
        remove_index table_name.to_sym, name: index.name
      end

      ActiveRecord::Base.connection.foreign_keys(table_name).each do |fk|
        remove_foreign_key table_name.to_sym, name: fk.options[:name]
      end
    end

    rename_table :current_interlinks, :current_interlanguage_relations
    rename_table :interlinks, :interlanguage_relations
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'No.'
  end
end
