# encoding: utf-8

namespace :ruwikt do
  desc 'Load the Russian Wiktionary in YARN format'
  task :load => :environment do
    raise 'Missing ENV["filename"]' unless ENV['filename']

    words = {}

    xml = Nokogiri::XML(File.read(ENV['filename']))
    xml.xpath('//wordEntry').each do |entry|
      id, author, timestamp = entry[:id], entry[:author], entry[:timestamp]

      next unless word = entry.xpath('./word[1]').map(&:text).first
      grammar = entry.xpath('./grammar[1]').map(&:text).first

      accents = entry.xpath('./accent').map(&:text).map(&:to_i)
      uris = entry.xpath('./url').map(&:text)

      words[id] = Word.new(word: word, grammar: grammar, accents: accents,
        uris: uris)

      if words.size % 50 == 0
        Rails.logger.info '%d words loaded' % [words.size]
      end
    end

    Rails.logger.info 'Starting importing words'
    Word.import(words.values)
    Rails.logger.info 'Finished importing words'

    synsets = {}

    xml.xpath('//synsetEntry').each do |entry|
      id, author, timestamp = entry[:id], entry[:author], entry[:timestamp]

      definitions = entry.xpath('./definition').map do |definition|
        { url: definition[:url], source: definition[:source] }
      end

      words = entry.xpath('./word').map do |word|
        ref, nsg = word[:ref], word[:nonStandardGrammar] == 'true'

        samples = word.xpath('./sample').map do |sample|
          { sample: sample.text, source: sample[:source] }
        end

        marks = word.xpath('./mark').map(&:text)

        { ref: ref, nsg: nsg, samples: samples, marks: marks }
      end

      if synsets.size % 50 == 0
        Rails.logger.info '%d words loaded' % [synsets.size]
      end
    end

    Rails.logger.info 'Starting importing synsets'
    Word.import(synsets.values)
    Rails.logger.info 'Finished importing synsets'
  end
end
