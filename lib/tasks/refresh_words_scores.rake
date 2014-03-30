namespace :yarn do
  desc 'Refresh the "current_words_scores" materialized view'
  task :refresh_words_scores => :environment do
    ActiveRecord::Base.connection.execute \
      'REFRESH MATERIALIZED VIEW current_words_scores;'
  end
end
