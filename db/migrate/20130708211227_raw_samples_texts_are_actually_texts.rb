class RawSamplesTextsAreActuallyTexts < ActiveRecord::Migration
  def change
    change_table :raw_samples do |t|
      t.change :text, :text
    end
  end
end
