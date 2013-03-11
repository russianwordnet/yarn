# encoding: utf-8

namespace :ruwikt do
  desc 'Load the Russian Wiktionary in YARN format'
  task :load => :environment do
    raise 'Missing ENV["filename"]' unless ENV['filename']

    xml = Nokogiri::XML(File.read(ENV['filename']))
    xml.xpath('//wordEntry').each do |entry|
      id, author, timestamp = entry[:id], entry[:author], entry[:timestamp]

      next unless word = entry.xpath('./word[1]').map(&:text).first
      grammar = entry.xpath('./grammar[1]').map(&:text).first

      accents = entry.xpath('./accent').map(&:text).map(&:to_i)
      urls = entry.xpath('./url').map(&:text)
    end

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
    end
  end
end
