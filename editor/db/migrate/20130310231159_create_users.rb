class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :provider
      t.string :uid
      t.timestamps
    end

    change_table :users do |t|
      t.index :name
      t.index [:provider, :uid], unique: true
    end
  end
end
