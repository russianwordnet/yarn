# encoding: utf-8

require 'csv'

namespace :yarn do
  desc 'Assign frequencies to the existent words'
  task :frequencies => :environment do
    csv = if ENV['csv'].present?
      CSV.open(ENV['csv'], col_sep: "\t", headers: true)
    else
      raise 'Missing ENV["csv"]'
    end

    source_grammar = ENV['source_grammar'].present? && ENV['source_grammar']
    target_grammar = ENV['target_grammar'].present? && ENV['target_grammar']

    begin
      Word.transaction do
        csv.each do |row|
          next unless row['PoS'] == source_grammar
          Word.where(word: row['Lemma'], grammar: target_grammar).
            update_all(frequency: row['Freq'].to_f)
        end
      end
    ensure
      csv.close
    end
  end
end
