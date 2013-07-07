# encoding: utf-8

# Please don't change this magic constant, ha-ha.
#
BUFFER_SIZE = 228

namespace :yarn do
  desc 'Find such words in a dictionary in the YARN format that already exist in the current lexicon'
  task :duplicates => :environment do
    raise 'Missing ENV["xml"]' unless ENV['xml']
    output = ENV['output'] || ENV['xml'] + '.duplicates.csv'

    xml = Nokogiri::XML(File.open(ENV['xml']))

    puts 'Hey, there are %d words in "%s".' % [
      xml.xpath('//wordEntry').size,
      ENV['xml']
    ]

    xml.xpath('//wordEntry').each_slice(BUFFER_SIZE) do |entries|
      buffer = entries.inject({}) do |h, entry|
        next h unless id = entry[:id]
        next h unless lexeme = entry.xpath('./word[1]').map(&:text).first
        h[id] = lexeme; h
      end

      Word.where(word: buffer.values).each do |word|
        duplicates[buffer.key word.word] = word.id
      end
    end

    CSV.open(output, 'w') do |csv|
      duplicates.each do |*values|
        csv << values
      end
    end
  end
end
