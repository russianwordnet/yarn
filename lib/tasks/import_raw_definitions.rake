namespace :yarn do
  namespace :import do
    desc 'Import synsets from a CSV file'
    task :raw_definitions => :environment do
      if dry = ENV['dry'].present?
        STDERR.puts 'Working in dry mode, changes will not be made.'
      end

      tsv = if ENV['tsv'].present?
        CSV.open(ENV['tsv'], col_sep: "\t", quote_char: "\x00")
      else
        raise 'Missing ENV["tsv"]'
      end

      grammar = if ENV['grammar'].present?
        grammar = ENV['grammar']
      else
        raise 'Missing ENV["grammar"]'
      end

      source = if ENV['source'].present?
        source = ENV['source']
      else
        raise 'Missing ENV["source"]'
      end

      author_id = if ENV['author_id'].present?
        author_id = ENV['author_id'].to_i
      else
        raise 'Missing ENV["author_id"]'
      end

      reset_pk_sequences = proc do
        ActiveRecord::Base.connection.reset_pk_sequence! Word.table_name
        ActiveRecord::Base.connection.reset_pk_sequence! Definition.table_name
        ActiveRecord::Base.connection.reset_pk_sequence! RawDefinition.table_name
      end

      reset_pk_sequences.call unless dry

      tsv.each_slice(228) do |slice|
        word_entries = slice.map(&:first)
        words = Word.where(word: word_entries, grammar: grammar, deleted_at: nil).group_by(&:word)

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

        Definition.transaction do
          RawDefinition.transaction do
            slice.each do |word, text|
              definition = Definition.create!(text: text, source: source) do |definition|
                definition.author_id = author_id
              end

              raw_definition = RawDefinition.create!(definition: definition, word: words[word].first) do |raw_definition|
                raw_definition.author_id = author_id
              end
            end
          end
        end
      end
    end
  end
end
