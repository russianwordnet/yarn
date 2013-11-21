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

    duplicates = {}

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
      duplicates.each do |entry_id, word_id, _|
        csv << [entry_id, word_id]
      end
    end

    puts 'Output of %d duplicates is written to "%s"' %
      [duplicates.size, output]
  end

  desc 'Merge duplicate lexemes'
  task :merge_lexemes => :environment do
    query = %Q{SELECT DISTINCT ON (#{Word.table_name}.word)
                 #{Word.table_name}.id, #{Word.table_name}.word,
                 duplicate_words.id AS duplicate_id,
                 duplicate_words.word AS duplicate_word
               FROM #{Word.table_name}
               INNER JOIN #{Word.table_name} AS duplicate_words ON
                 duplicate_words.word = #{Word.table_name}.word AND
                 duplicate_words.id <> #{Word.table_name}.id
               WHERE current_words.deleted_at IS NULL AND
                 duplicate_words.deleted_at IS NULL}

    rows = ActiveRecord::Base.connection.execute(query)
    puts 'Found %d duplicates' % rows.size

    def update_object(object, delta)
      attributes = object.attributes.merge(delta)
      object.update_from(OpenStruct.new(attributes))
    end

    rows.each_with_index do |row, i|
      id1, id2 = row.values_at('id', 'duplicate_id')
      common_id, removed_id = [id1, id2].min, [id1, id2].max

      Word.transaction do
        SynsetWord.where(word_id: removed_id).each do |sw|
          update_object(sw, 'word_id' => common_id)
        end

        RawSynsetWord.where(word_id: removed_id).
          update_all(word_id: common_id)
        OldSynsetWord.where(word_id: removed_id).
          update_all(word_id: common_id)

        AntonomyRelation.where(word1_id: removed_id).each do |ar|
          update_object(ar, 'word1_id' => common_id)
        end
        AntonomyRelation.where(word2_id: removed_id).each do |ar|
          update_object(ar, 'word2_id' => common_id)
        end

        OldAntonomyRelation.where(word1_id: removed_id).
          update_all(word1_id: common_id)
        OldAntonomyRelation.where(word2_id: removed_id).
          update_all(word2_id: common_id)

        WordRelation.where(word1_id: removed_id).each do |ar|
          update_object(ar, 'word1_id' => common_id)
        end
        WordRelation.where(word2_id: removed_id).each do |ar|
          update_object(ar, 'word2_id' => common_id)
        end

        OldWordRelation.where(word1_id: removed_id).
          update_all(word1_id: common_id)
        OldWordRelation.where(word2_id: removed_id).
          update_all(word2_id: common_id)

        Word.find(removed_id).update_attribute(:deleted_at, DateTime.now)
      end

      puts '%d rows have been processed' % (i + 1) if (i + 1) % 100 == 0 || (i + 1) == rows.size
    end
  end
end
