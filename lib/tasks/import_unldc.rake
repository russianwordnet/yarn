namespace :yarn do
  namespace :import do
    desc 'Import synsets from UNLDC'
    task :unldc => :environment do
      if dry = ENV['dry'].present?
        STDERR.puts 'Working in dry mode, changes will not be saved.'
      end

      # russian-synsets.csv is actually a TSV file
      tsv = if ENV['tsv'].present?
        # since double quotes are invalid in that file, ignore them
        CSV.open(ENV['tsv'], skip_lines: /^ *#/, col_sep: "\t", quote_char: "\x00")
      else
        raise 'Missing ENV["tsv"]'
      end

      author_id = if ENV['author_id'].present?
        author_id = ENV['author_id'].to_i
      else
        raise 'Missing ENV["author_id"]'
      end

      reset_pk_sequences = proc do
        ActiveRecord::Base.connection.reset_pk_sequence! Word.table_name
        ActiveRecord::Base.connection.reset_pk_sequence! Synset.table_name
        ActiveRecord::Base.connection.reset_pk_sequence! SynsetWord.table_name
        ActiveRecord::Base.connection.reset_pk_sequence! SynsetInterlink.table_name
      end

      reset_pk_sequences.call unless dry

      tsv.each_slice(100) do |slice|
        slice.each do |row|
          word_entries, reference = row[0].split(','), row[2]
          words = Word.where(word: word_entries).where(deleted_at: nil).group_by(&:word)
          next if words.empty?

          # insert the missing lexical entries if at least one of
          # synset's words exists in the lexicon
          if (diff = word_entries - words.keys).any?
            Word.transaction do
              diff.each do |w|
                begin
                  Word.create!(word: w) do |word|
                    word.author_id = author_id
                    (words[w] ||= []) << word
                  end
                rescue ActiveRecord::RecordNotUnique
                rescue ActiveRecord::RecordInvalid
                end
              end

              raise ActiveRecord::Rollback if dry
            end
          end
        end

        Synset.transaction do
          slice.each do |row|
            word_entries, reference = row[0].split(','), row[2]
            words = Word.where(word: word_entries).where(deleted_at: nil).group_by(&:word)
            next if words.empty?

            Synset.create! do |synset|
              SynsetWord.transaction do
                words.values.flatten!.each do |word|
                  SynsetWord.create!(word: word) do |sw|
                    sw.author_id = author_id
                  end.tap { |sw| synset.words_ids += [sw.id] }
                end

                raise ActiveRecord::Rollback if dry
              end

              synset.author_id = author_id
            end.tap do |synset|
              synset.interlinks.create!(source: 'UNLDC', foreign_id: reference) do |il|
                il.author_id = author_id
              end
            end
          end

          raise ActiveRecord::Rollback if dry
        end
      end

      reset_pk_sequences.call unless dry
    end
  end
end
