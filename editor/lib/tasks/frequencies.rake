# encoding: utf-8

require 'csv'

namespace :yarn do
  desc 'Assign frequencies to the existent words'
  task :frequencies => :environment do
    raise 'Missing ENV["filename"]' unless ENV['filename']

    Word.transaction do
      CSV.foreach(filename) do |row|
        Word.where(word: row[0]).update_all(frequency: row[1])
      end
    end
  end
end
