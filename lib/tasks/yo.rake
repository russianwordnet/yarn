# encoding: utf-8

def create_synset_word(author_id, word_id)
  SynsetWord.new.tap do |sw|
    sw.author_id = author_id
    sw.word_id = word_id
  end
end

def create_synset(author_id, *synset_words)
  Synset.new.tap do |s|
    s.author_id = author_id
    s.words_ids = synset_words.map(&:id)
  end
end

namespace :yarn do
  desc 'Merge "E" and "YO" lexemes into synsets'
  task :yo => :environment do
    raise 'Missing ENV["author_id"]' unless ENV['author_id']
    author_id = ENV['author_id'].to_i

    query = %Q{SELECT #{Word.table_name}.id,
                 yoless_words.id AS yoless_id,
                 yoless_words.word, yoless_words.yoless_word
               FROM #{Word.table_name}
               INNER JOIN 
                 (SELECT id, word, replace(replace(word, 'ё', 'е'), 'Ё', 'Е')
                   AS yoless_word FROM #{Word.table_name}
                     WHERE word SIMILAR TO '%[Ёё]%')
                 AS yoless_words
                 ON yoless_words.yoless_word = #{Word.table_name}.word
               WHERE #{Word.table_name}.word = yoless_word}

    rows = ActiveRecord::Base.connection.execute(query)
    puts 'Found %d "E"-"YO" similarities' % rows.size

    rows.each_with_index do |row, i|
      id1, id2 = row.values_at 'id', 'yoless_id'

      Synset.transaction do
        sw1 = create_synset_word(author_id, id1).tap(&:save!)
        sw2 = create_synset_word(author_id, id2).tap(&:save!)
        create_synset(author_id, sw1, sw2).tap(&:save!)
      end

      puts '%d synsets created' % (i + 1) if (i + 1) % 100 == 0 || (i + 1) == rows.size
    end
  end
end
