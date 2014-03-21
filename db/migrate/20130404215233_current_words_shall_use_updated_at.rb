class CurrentWordsShallUseUpdatedAt < ActiveRecord::Migration
  def change
    change_table :current_words do |t|
      t.rename :created_at, :updated_at
    end
  end
end
