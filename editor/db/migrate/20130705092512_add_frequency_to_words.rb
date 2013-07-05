class AddFrequencyToWords < ActiveRecord::Migration
  def change
    change_table :current_words do |t|
      t.integer :frequency, null: false, default: 0
      t.index :frequency
    end

    change_table :words do |t|
      t.integer :frequency, null: false, default: 0
      t.index :frequency
    end
  end
end
