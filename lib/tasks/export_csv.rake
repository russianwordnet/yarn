namespace :yarn do
  namespace :export do
    desc 'Export the thesaurus in the CSV format to /public/yarn-*.csv'
    task :csv => %i(csv:synsets)

    namespace :csv do
      task :synsets => :environment do
        synsets = Synset.select('current_synsets.id, array_agg(current_words.word) AS words_agg, array_agg(current_words.grammar) AS grammars_agg').
          joins(:words).joins(:words => :word).includes(:domain).
          where(current_synset_words: { deleted_at: nil }).
          where(current_words: { deleted_at: nil}).
          where(deleted_at: nil).
          group('current_synsets.id').
          order(:id).tap { |s| puts s.to_sql }

        CSV.open(Rails.root.join('public', 'yarn-synsets.csv'), 'w') do |csv|
          csv << %w(id words grammar domain)
          synsets.find_each do |synset|
            next if synset.words_agg.empty?
            words_csv = synset.words_agg.to_csv(col_sep: ';').tap(&:chomp!)

            if synset.grammars_agg.any? { |g| !%w(n a v).include? g }
              puts 'Careful: synset #%d has strange grammars: %s' % [synset.id, synset.grammars_agg.join(',')]
            end

            grammar = synset.grammars_agg.
              group_by { |x| x }.
              map { |k, v| [k, v.size] }.
              sort { |(_, v1), (_, v2)| v2 <=> v1 }.
              first[0]

            csv << [synset.id, words_csv, grammar, synset.try(:domain).try(:name)]
          end
        end
      end
    end
  end
end
