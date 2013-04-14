# encoding: utf-8

namespace :ruwikt do
  desc 'Load the Russian Wiktionary in YARN format'
  task :load => :environment do
    raise 'Missing ENV["filename"]' unless ENV['filename']

    xml = Nokogiri::XML(File.read(ENV['filename']))

    puts 'Hey, there are %d words and %d synsets in "%s".' % [
      xml.xpath('//wordEntry').size,
      xml.xpath('//synsetEntry').size,
      ENV['filename']
    ]

    word_count, synset_count = 0, 0
    definition_count, synset_word_count, sample_count = 0, 0, 0

    xml.xpath('//wordEntry').each_slice(500) do |entries|
      words = entries.map do |entry|
        id, author, timestamp = entry[:id], entry[:author],
          entry[:timestamp]

        next unless word = entry.xpath('./word[1]').map(&:text).first
        grammar = entry.xpath('./grammar[1]').map(&:text).first

        accents = entry.xpath('./accent').map(&:text).map(&:to_i)
        uris = entry.xpath('./url').map(&:text)

        Word.new(word: word, grammar: grammar, accents: accents,
          uris: uris).tap { |w| w.id = id[/\d+/] }
      end

      Word.transaction { words.each(&:save!) }
      puts '%d words loaded' % (word_count += words.size)
    end

    ActiveRecord::Base.connection.reset_pk_sequence! Word.table_name

    xml.xpath('//synsetEntry').each_slice(200) do |entries|
      synsets = entries.map do |entry|
        id, author, timestamp = entry[:id], entry[:author], entry[:timestamp]

        definitions = entry.xpath('./definition').map do |definition|
          Definition.new(text: definition.text, source: definition[:source],
            uri: definition[:url])
        end

        unless definitions.empty?
          Definition.transaction { definitions.each(&:save!) }
          puts '%d definitions loaded' % (definition_count += definitions.size)
        end

        synset_words = entry.xpath('./word').map do |word|
          ref, nsg = word[:ref], word[:nonStandardGrammar] == 'true'

          samples = word.xpath('./sample').map do |sample|
            Sample.new(text: sample.text, source: sample[:source],
              uri: sample[:url])
          end

          unless samples.empty?
            Sample.transaction { samples.each(&:save!) }
            puts '%d samples loaded' % (sample_count += samples.size)
          end

          marks = word.xpath('./mark').map(&:text)

          SynsetWord.new(samples_ids: samples.map(&:id), marks: marks,
            nsg: nsg).tap { |sw| sw.word_id = ref && ref[/\d+/] }
        end

        unless synset_words.empty?
          SynsetWord.transaction { synset_words.each(&:save!) }
          puts '%d synset words loaded' % (synset_word_count += synset_words.size)
        end

        Synset.new(definitions_ids: definitions.map(&:id),
          words_ids: synset_words.map(&:id)).tap { |w| w.id = id[/\d+/] }
      end

      Synset.transaction { synsets.each(&:save!) }
      puts '%d synsets loaded' % (synset_count += synsets.size)
    end

    ActiveRecord::Base.connection.reset_pk_sequence! Synset.table_name
  end
end
