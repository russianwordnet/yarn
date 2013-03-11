# encoding: utf-8

namespace :ruwikt do
  desc 'Load the Russian Wiktionary in YARN format'
  task :load => :environment do
    raise 'Missing ENV["filename"]' unless ENV['filename']

    xml = Nokogiri::XML(File.read(ENV['filename']))
    xml.xpath('//wordEntry').each do |we|
      id, author, timestamp = we[:id], we[:author], we[:timestamp]

      word = we.children.find { |e| e.name == 'word' }.text
      grammar = we.children.find { |e| e.name == 'grammar' }.text rescue nil

      accents = we.children.
        select { |e| e.name == 'accent' }.
        map { |e| e.text.to_i }

      urls = we.children.select { |e| e.name == 'url' }.map { |e| e.text }
    end
  end
end
