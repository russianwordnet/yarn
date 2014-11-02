namespace :yarn do
  namespace :import do
    desc 'Import synonyms in the CSV import format'
    task :synonyms => :environment do
      if dry = ENV['dry'].present?
        STDERR.puts 'Working in dry mode, changes will not be made.'
      end

      csv = if ENV['csv'].present?
        CSV.open(ENV['csv'], headers: true)
      else
        raise 'Missing ENV["csv"]'
      end

      author_id = if ENV['author_id'].present?
        author_id = ENV['author_id'].to_i
      else
        raise 'Missing ENV["author_id"]'
      end

      grammar = ENV['grammar'].present? && ENV['grammar']

      ActiveRecord::Base.connection.reset_pk_sequence! RawSynonymy.table_name unless dry
      
      begin
        csv.each_slice(100) do |slice|
          RawSynonymy.transaction do
            entries = slice.map { |s| [s['word1'], s['word2']] }.flatten!.uniq
            words = Word.where(word: entries, grammar: grammar).group_by(&:word)

            if (diff = entries - words.keys).any?
              Word.transaction do
                diff.each do |w|
                  Word.create(word: w, grammar: grammar) do |word|
                    word.author_id = author_id
                    (words[w] ||= []) << word
                  end
                end

                raise ActiveRecord::Rollback if dry
              end
            end

            slice.each do |row|
              synonyms = [row['word1'], row['word2']].map! do |entry|
                candidates = words[entry].sort_by! do |c|
                  [-c.frequency, !c.deleted_at ? 1 : 0, c.id]
                end
                candidates.first
              end.sort_by!(&:id)

              next if synonyms[0] == synonyms[1]

              begin
                RawSynonymy.create! do |rs|
                  rs.word1_id = synonyms[0].id
                  rs.word2_id = synonyms[1].id
                  rs.author_id = author_id
                end
              rescue ActiveRecord::RecordNotUnique
              rescue ActiveRecord::RecordInvalid
              end
            end

            raise ActiveRecord::Rollback if dry
          end
        end
      ensure
        csv.close
      end

      ActiveRecord::Base.connection.reset_pk_sequence! RawSynonymy.table_name unless dry
    end
  end
end
