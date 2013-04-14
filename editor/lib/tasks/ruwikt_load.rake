# encoding: utf-8

namespace :ruwikt do
  desc 'Load the Russian Wiktionary in YARN format'
  task :load => :environment do
    raise 'Missing ENV["filename"]' unless ENV['filename']

    xml = Nokogiri::XML(File.read(ENV['filename']))

    puts 'Hey, there are %d words and %d synsets in "%s"' % [
      xml.xpath('//wordEntry').size,
      xml.xpath('//synsetEntry').size,
      ENV['filename']
    ]

    words = []

    xml.xpath('//wordEntry').each_slice(500) do |entries|
      bucket = entries.map do |entry|
        id, author, timestamp = entry[:id], entry[:author], entry[:timestamp]

        next unless word = entry.xpath('./word[1]').map(&:text).first
        grammar = entry.xpath('./grammar[1]').map(&:text).first

        accents = entry.xpath('./accent').map(&:text).map(&:to_i)
        uris = entry.xpath('./url').map(&:text)

        Word.new(word: word, grammar: grammar, accents: accents, uris: uris)
      end

      words.concat(bucket)
      Word.transaction { bucket.each(&:save!) }
      puts '%d words loaded' % words.size
    end

    definitions, synset_words, samples, synsets = [], [], [], []

    xml.xpath('//synsetEntry').each_slice(200) do |entries|
      bucket = entries.map do |entry|
        id, author, timestamp = entry[:id], entry[:author], entry[:timestamp]

        defs_bucket = entry.xpath('./definition').map do |defn|
          Definition.new(text: defn.text,
            source: defn[:source],
            uri: defn[:url])
        end

        unless defs_bucket.empty?
          definitions.concat(defs_bucket)
          Definition.transaction { defs_bucket.each(&:save!) }
          puts '%d definitions loaded' % definitions.size
        end

        swords_bucket = entry.xpath('./word').map do |word|
          ref, nsg = word[:ref], word[:nonStandardGrammar] == 'true'

          samples_bucket = word.xpath('./sample').map do |sample|
            Sample.new(text: sample.text, source: sample[:source],
              uri: sample[:url])
          end

          unless samples_bucket.empty?
            samples.concat(samples_bucket)
            Sample.transaction { samples_bucket.each(&:save!) }
            puts '%d samples loaded' % samples.size
          end

          marks = word.xpath('./mark').map(&:text)

          SynsetWord.new(samples_ids: samples.map(&:id),
            marks: marks, nsg: nsg)
        end

        unless swords_bucket.empty?
          synset_words.concat(swords_bucket)
          SynsetWord.transaction { swords_bucket.each(&:save!) }
          puts '%d synset words loaded' % synset_words.size
        end

        Synset.new(definitions_ids: defs_bucket.map(&:id),
          words_ids: swords_bucket.map(&:id))
      end

      synsets.concat(bucket)
      Synset.transaction { bucket.each(&:save!) }
      puts '%d synsets loaded' % synsets.size
    end
  end
end
