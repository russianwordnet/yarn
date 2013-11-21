# encoding: utf-8

namespace :yarn do
  desc 'Remove the lexemes garbage in the batch mode'
  task :lexemes_garbage => :environment do
    raise 'Missing ENV["string"]' unless string = ENV['string']
    raise 'Missing ENV["author_id"]' unless author_id = ENV['author_id']

    subst = ENV['subst'] || ''

    puts 'Removing the "%s" string from the existing lexemes' % string
    rows = Word.where('word SIMILAR TO ?', '%%%s%%' % string)
    puts rows.to_sql

    rows.each_with_index do |word, i|
      attributes = word.attributes
      attributes['word'] = attributes['word'].gsub(string, subst)
      attributes['author_id'] = author_id
      word.update_from(OpenStruct.new(attributes))
      puts '%d words were affected' % (i + 1) if (i + 1) % 100 == 0 || (i + 1) == rows.size
    end
  end
end
