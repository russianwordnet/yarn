# encoding: utf-8

namespace :yarn do
  desc 'Substitute all lexemes using a pattern'
  task :gsub => :environment do
    raise 'Missing ENV["pattern"]' unless pattern = ENV['pattern']
    raise 'Missing ENV["author_id"]' unless author_id = ENV['author_id']

    regexp = Regexp.new(pattern)
    subst = ENV['subst'] || ''

    puts 'Substituting the %s pattern to %s' % [regexp.inspect, subst.inspect]
    rows = Word.where('word ~* ?', pattern)
    puts rows.to_sql

    rows.each_with_index do |word, i|
      attributes = word.attributes
      attributes['word'] = attributes['word'].gsub(regexp, subst)
      attributes['author_id'] = author_id
      puts 'Changing "%s" to "%s"' % [word.word, attributes['word']]
      word.update_from(OpenStruct.new(attributes))
    end
  end
end
