class NonNullTypeInRawRelations < ActiveRecord::Migration
  def up
    execute "UPDATE raw_relations SET type = 'hypernymy';"
    change_column_null :raw_relations, :type, false
  end

  def down
    change_column_null :raw_relations, :type, true
  end
end
