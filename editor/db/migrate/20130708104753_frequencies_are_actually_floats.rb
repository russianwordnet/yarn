class FrequenciesAreActuallyFloats < ActiveRecord::Migration
  def change
    change_table :current_words do |t|
      t.change :frequency, :float, default: 0.0
    end

    change_table :words do |t|
      t.change :frequency, :float, default: 0.0
    end
  end
end
