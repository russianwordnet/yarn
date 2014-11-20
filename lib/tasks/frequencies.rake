# encoding: utf-8

require 'csv'

namespace :yarn do
  desc 'Provide words with the RNC frequencies'
  task :frequencies => :environment do
    csv = if ENV['csv'].present?
      CSV.open(ENV['csv'], col_sep: "\t", headers: true)
    else
      raise 'Missing ENV["csv"]'
    end

    source_grammar = ENV['source_grammar'].present? && ENV['source_grammar']
    target_grammar = ENV['target_grammar'].present? && ENV['target_grammar']
    create_missing = ENV['create_missing'].present? && ENV['create_missing']

    author_id = if create_missing
      if ENV['author_id'].present?
        author_id = ENV['author_id'].to_i
      else
        raise 'Missing ENV["author_id"]'
      end
    end

    begin
      Word.transaction do
        csv.each do |row|
          next unless row['PoS'] == source_grammar
          set = Word.where(word: row['Lemma'], grammar: target_grammar)
          frequency = row['Freq'].to_f

          if create_missing && set.empty?
            Word.create!(word: row['Lemma'], grammar: target_grammar, frequency: frequency) do |word|
              word.author_id = author_id
            end
          elsif !create_missing
            set.update_all(frequency: frequency)
          end
        end
      end
    ensure
      csv.close
    end
  end
end
