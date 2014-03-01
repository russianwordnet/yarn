class RefreshWordScores < ActiveRecord::Migration
  def up
    puts 'This operation is quite long. Keep calm and carry on.'
    execute 'REFRESH MATERIALIZED VIEW word_scores;'
  end

  def down
  end
end
