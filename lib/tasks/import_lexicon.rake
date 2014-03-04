namespace :yarn do
  namespace :import do
    desc 'Import a lexicon in the XML import format'
    task :lexicon => :environment do
      require File.expand_path('../../yarn_raw_xml', __FILE__)

      if dry = ENV['dry'].present?
        STDERR.puts 'Working in dry mode, changes will not be made.'
      end

      xml = if ENV['xml'].present?
        Yarn::Raw::SAX.parse(File.open(ENV['xml']))
      else
        raise 'Missing ENV["xml"]'
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
        ActiveRecord::Base.connection.reset_pk_sequence! Sample.table_name
        ActiveRecord::Base.connection.reset_pk_sequence! RawExample.table_name
      end

      reset_pk_sequences.call unless dry

      xml.lexicon.entries.each_slice(100) do |slice|
        Word.transaction do
        Definition.transaction do
        RawDefinition.transaction do
        Sample.transaction do
        RawExample.transaction do
          words = Word.where(word: slice.map(&:word)).group_by(&:word)

          slice.each do |entry|
            candidates = words[entry.word].sort_by! do |c|
              [-c.frequency, !c.deleted_at ? 1 : 0, c.id]
            end

            entry.word = if candidates
              puts 'Mapping the duplicate word "%s" to ID=%d' % [entry.word, candidates.first.id]
              candidates.first
            else
              Word.create!(word: entry.word, grammar: entry.grammar) do |word|
                word.author_id = author_id
                word.accents = entry.accents.map(&:to_i)
              end
            end

            entry.definitions.each do |dentry|
              definition = Definition.create!(text: dentry.text, source: dentry.source, uri: dentry.url) do |definition|
                definition.author_id = author_id
              end

              raw_definition = RawDefinition.create!(definition: definition, word: entry.word) do |raw_definition|
                raw_definition.author_id = author_id
              end

              dentry.text = raw_definition

              dentry.examples.each do |xentry|
                example = Sample.create!(text: xentry.text, source: xentry.source, uri: xentry.url) do |example|
                  example.author_id = author_id
                end

                raw_example = RawExample.create!(example: example, raw_definition: dentry.text) do |raw_example|
                  raw_example.author_id = author_id
                end

                xentry.text = raw_example
              end
            end
          end

          raise ActiveRecord::Rollback if dry; end
          raise ActiveRecord::Rollback if dry; end
          raise ActiveRecord::Rollback if dry; end
          raise ActiveRecord::Rollback if dry; end
          raise ActiveRecord::Rollback if dry
        end
      end

      reset_pk_sequences.call unless dry
    end
  end
end
