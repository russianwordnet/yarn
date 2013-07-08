class SourcesAreNowTexts < ActiveRecord::Migration
  def change
    change_table :current_definitions do |t|
      t.change :source, :text
    end

    change_table :definitions do |t|
      t.change :source, :text
    end

    change_table :current_samples do |t|
      t.change :source, :text
    end

    change_table :samples do |t|
      t.change :source, :text
    end

    change_table :raw_samples do |t|
      t.change :source, :text
    end
  end
end
