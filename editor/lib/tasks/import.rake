# encoding: utf-8

require File.expand_path('lib/yarn_sax', Rails.root)

# Load the duplicated words list and represent it as a Hash.
#
def load_duplicates(filename)
  Hash.new.tap do |duplicates|
    CSV.foreach(filename) do |row|
      duplicates[row[0]] = row[1].to_i
    end
  end
end

# Create an instance of the Word class.
#
def new_word(sax, author_id, offset = 0)
  Word.new.tap do |word|
    word.id = offset + sax.id[/\d+/].to_i
    word.author_id = author_id
    word.word = sax.word
    word.grammar = sax.grammar
    word.accents = sax.accents
    word.uris = sax.uris
  end
end

# Create an instance of the Definition class.
#
def new_definition(sax, author_id)
  Definition.new.tap do |definition|
    definition.author_id = author_id
    definition.text = sax.text
    definition.source = sax.source
    definition.uri = sax.uri
  end
end

# Create an instance of the RawSynset class.
#
def new_synset(sax, author_id, offset = 0)
  RawSynset.new.tap do |synset|
    synset.id = offset + sax.id[/\d+/].to_i
    synset.author_id = author_id
    synset.words_ids = sax.words.map(&:id)
    synset.definitions_ids = sax.definitions.map(&:id)
  end
end

# Create an instance of the RawSynsetWord class.
#
def new_synset_word(sax, author_id, word_id)
  RawSynsetWord.new.tap do |synset_word|
    synset_word.author_id = author_id
    synset_word.word_id = word_id
    synset_word.samples_ids = sax.samples.map(&:id)
    synset_word.marks = sax.marks
  end
end

# Create an instance of the Sample class.
#
def new_sample(sax, author_id)
  Sample.new.tap do |sample|
    sample.author_id = author_id
    sample.text = sax.text
    sample.source = sax.source
    sample.uri = sax.uri
  end
end

# Create an instance of SynsetRelation class.
#
def new_synset_relation(sax, author_id)
  SynsetRelation.new.tap do |relation|
    relation.author_id = author_id
    relation.synset1_id = sax.synset1_id
    relation.synset2_id = sax.synset2_id
  end
end

# Create an instance of WordRelation class.
#
def new_word_relation(sax, author_id)
  WordRelation.new.tap do |relation|
    relation.author_id = author_id
    relation.word1_id = sax.word1_id
    relation.word2_id = sax.word2_id
  end
end

# Create an instance of AntonomyRelation class.
#
def new_word_relation(sax, author_id)
  AntonomyRelation.new.tap do |relation|
    relation.author_id = author_id
    relation.synset1_id = sax.synset1_id
    relation.synset2_id = sax.synset2_id
    relation.word1_id = sax.word1_id
    relation.word2_id = sax.word2_id
  end
end

# Create an instance of Interlink class.
#
def new_interlink(sax, author_id)
  Interlink.new.tap do |interlink|
    interlink.author_id = author_id
    interlink.synset_id = sax.synset_id
    interlink.pwn = sax.pwn
  end
end

namespace :yarn do
  desc 'Import a dictionary in the YARN format'
  task :import => :environment do
    raise 'Missing ENV["xml"]' unless ENV['xml']
    raise 'Missing ENV["author_id"]' unless ENV['author_id']

    duplicates = if ENV['duplicates']
      load_duplicates(ENV['duplicates'])
    else
      {}
    end

    ignore_new_words = !!ENV['ignore_new_words']

    author_id = ENV['author_id'].to_i

    words_count, synsets_count = 0, 0
    synset_relations_count, word_relations_count = 0, 0
    antonomy_relations_count, interlinks_count = 0, 0

    words_offset = Word.maximum(:id) || 0
    synsets_offset = RawSynset.maximum(:id) || 0

    puts 'Initializing "%s"' % ENV['xml']
    yarn = YarnSAX.parse(File.open(ENV['xml']))

    puts 'Started parsing words'
    unless ignore_new_words
      (yarn.words.entries || []).each_slice(1228) do |words|
        Word.transaction do
          words.map! do |word|
            next if duplicates.has_key? word.id
            new_word(word, author_id, words_offset).tap(&:save!)
          end.compact!
        end
        puts '%d words done' % (words_count += words.size)
      end
    end
    puts 'Finished parsing words'

    puts 'Started parsing synsets'
    (yarn.synsets.entries || []).each_slice(228) do |synsets|
      synsets.map! do |synset|
        Definition.transaction do
          synset.definitions.map! do |definition|
            new_definition(definition, author_id).tap(&:save!)
          end
        end

        synset.words.map! do |synset_word|
          word_id = if duplicates.has_key? synset_word.ref
            duplicates[synset_word.ref]
          elsif ignore_new_words
          else
            words_offset + synset_word.ref[/\d+/].to_i
          end

          next unless word_id

          RawSynsetWord.transaction do
            synset_word.samples.map! do |sample|
              new_sample(sample, author_id).tap(&:save!)
            end
          end

          new_synset_word(synset_word, author_id, word_id)
        end

        synset.words.compact!

        RawSynsetWord.transaction { synset.words.each(&:save!) }

        new_synset(synset, author_id, synsets_offset)
      end.compact!

      synsets.reject! { |s| s.words_ids.empty? && s.definitions_ids.empty? }

      RawSynset.transaction { synsets.each(&:save!) }
      puts '%d synsets done' % (synsets_count += synsets.size)
    end
    puts 'Finished parsing synsets'

    puts 'Started parsing synset relations'
    (yarn.synset_relations || []).each_slice(1228) do |relations|
      SynsetRelation.transaction do
        relations.map! do |relation|
          new_synset_relation(relation, author_id).tap(&:save!)
        end.compact!
      end
      puts '%d relations done' % (synset_relations_count += relations.size)
    end
    puts 'Finished parsing synset relations'

    puts 'Started parsing word relations'
    (yarn.word_relations || []).each_slice(1228) do |relations|
      WordRelation.transaction do
        relations.map! do |relation|
          new_word_relation(relation, author_id).tap(&:save!)
        end.compact!
      end
      puts '%d relations done' % (word_relations_count += relations.size)
    end
    puts 'Finished parsing word relations'

    puts 'Started parsing antonomy relations'
    (yarn.antonomy_relations || []).each_slice(1228) do |relations|
      AntonomyRelation.transaction do
        relations.map! do |relation|
          new_antonomy_relation(relation, author_id).tap(&:save!)
        end.compact!
      end
      puts '%d relations done' % (antonomy_relations_count += relations.size)
    end
    puts 'Finished parsing antonomy relations'

    ActiveRecord::Base.connection.reset_pk_sequence! Word.table_name
    ActiveRecord::Base.connection.reset_pk_sequence! Definition.table_name
    ActiveRecord::Base.connection.reset_pk_sequence! RawSynset.table_name
    ActiveRecord::Base.connection.reset_pk_sequence! RawSynsetWord.table_name
    ActiveRecord::Base.connection.reset_pk_sequence! Sample.table_name
    ActiveRecord::Base.connection.reset_pk_sequence! SynsetRelation.table_name
    ActiveRecord::Base.connection.reset_pk_sequence! WordRelation.table_name
    ActiveRecord::Base.connection.reset_pk_sequence! AntonomyRelation.table_name
    ActiveRecord::Base.connection.reset_pk_sequence! Interlink.table_name
    puts 'Done'
  end
end
