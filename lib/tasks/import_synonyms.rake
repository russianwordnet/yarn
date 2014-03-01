namespace :yarn do
  namespace :import do
    task :synonyms => :environment do
      require File.expand_path('../../yarn_raw_xml', __FILE__)

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

      ActiveRecord::Base.connection.reset_pk_sequence! RawSynonymy.table_name unless dry
      
      begin
        csv.each_slice(100) do |slice|
          RawSynonymy.transaction do
            entries = slice.map { |s| [s['word1'], s['word2']] }.flatten!.uniq
            words = Word.where(word: entries).group_by(&:word)

            if (diff = entries - words.keys).any?
              diff.each { |w| puts 'Unknown word "%s"' % w }
              raise 'Insufficient lexicon'
            end

            slice.each do |row|
              synonyms = [row['word1'], row['word2']].map! do |entry|
                candidates = words[entry].sort_by! do |c|
                  [-c.frequency, !c.deleted_at ? 1 : 0, c.id]
                end
                candidates.first
              end.sort_by!(&:id)

              begin
                RawSynonymy.create! do |rs|
                  rs.word1_id = synonyms[0].id
                  rs.word2_id = synonyms[1].id
                  rs.author_id = author_id
                end
              rescue ActiveRecord::RecordNotUnique
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
