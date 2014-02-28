class CreateMarkCategories < ActiveRecord::Migration
  def change
    create_table :mark_categories do |t|
      t.string :title, null: false
      t.timestamps
    end

    change_table :mark_categories do |t|
      t.index :title, unique: true
    end
  end
end
