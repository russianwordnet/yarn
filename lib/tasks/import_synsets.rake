namespace :yarn do
  namespace :import do
    desc 'Import synsets from a CSV file'
    task :synsets => :environment do
      if dry = ENV['dry'].present?
        STDERR.puts 'Working in dry mode, changes will not be made.'
      end

      csv = if ENV['csv'].present?
        CSV.open(ENV['csv'])
      else
        raise 'Missing ENV["csv"]'
      end

      grammar = if ENV['grammar'].present?
        grammar = ENV['grammar']
      else
        raise 'Missing ENV["grammar"]'
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
      end

      reset_pk_sequences.call unless dry

      csv.each_slice(100) do |slice|
        slice.each do |word_entries|
          word_entries.each { |w| w.gsub! /\p{Zs}/, ' ' }.
            each { |w| w.gsub! /[\p{C}\p{M}\p{Sk}]|[\p{Nd}&&[^\d]]/, '' }.
            each(&:strip!).each(&:scrub!)

          next if word_entries.any? { |w| w !~ /^[А-Яа-яЁё]+[А-Яа-яЁё -]*$/u.freeze }

          words = Word.where(word: word_entries, grammar: grammar, deleted_at: nil).group_by(&:word)
          next if words.empty?

          if (diff = word_entries - words.keys).any?
            Word.transaction do
              diff.each do |w|
                begin
                  Word.create!(word: w, grammar: grammar) do |word|
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
          slice.each do |word_entries|
            words = Word.where(word: word_entries, grammar: grammar, deleted_at: nil).group_by(&:word)
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
            end
          end

          raise ActiveRecord::Rollback if dry
        end
      end

      reset_pk_sequences.call unless dry
    end
  end
end
