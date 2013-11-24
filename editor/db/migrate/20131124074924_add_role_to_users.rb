class AddRoleToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :role
      t.index :role
    end
  end
end
