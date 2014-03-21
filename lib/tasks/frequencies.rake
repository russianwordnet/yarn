# encoding: utf-8

require 'csv'

namespace :yarn do
  desc 'Assign frequencies to the existent words'
  task :frequencies => :environment do
    raise 'Missing ENV["filename"]' unless ENV['filename']

    Word.transaction do
      CSV.foreach(ENV['filename'], col_sep: "\t", headers: true) do |row|
        next unless %w(s s.PROP).include? row['PoS']
        Word.where(word: row['Lemma']).update_all(frequency: row['Freq'].to_f)
      end
    end
  end
end
