class AddTimestampsToSynsets < ActiveRecord::Migration
  def change
    change_table :current_synsets do |t|
      t.timestamp :updated_at
    end

    change_table :synsets do |t|
      t.timestamp :created_at
    end
  end
end
