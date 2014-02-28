#!/usr/bin/env ruby
# encoding: utf-8

$semaphore = Mutex.new

def mputs(*args)
  $semaphore.synchronize { puts(*args) }
end

def definitions(word)
  Definition.
    where('current_definitions.id IN (SELECT unnest(raw_synsets.definitions_ids) FROM raw_synsets JOIN raw_synset_words ON raw_synsets.words_ids @> ARRAY[raw_synset_words.id] WHERE raw_synset_words.word_id = ?)', word).
    order(:id)
end

def synonyms(word)
  Word.
    select('DISTINCT ON (current_words.id) current_words.*').
    joins('JOIN raw_synset_words ON raw_synset_words.word_id = current_words.id').
    where('raw_synset_words.id IN (SELECT unnest(raw_synsets.words_ids) FROM raw_synsets JOIN raw_synset_words ON raw_synsets.words_ids @> ARRAY[raw_synset_words.id] WHERE raw_synset_words.word_id = ?)', word).
    where('current_words.id <> ?', word).
    order(:id)
end

def examples(word, definition)
  Sample.
    where('current_samples.id IN (SELECT DISTINCT unnest(raw_synset_words.samples_ids) FROM raw_synset_words JOIN raw_synsets ON raw_synsets.words_ids @> ARRAY[raw_synset_words.id] WHERE raw_synset_words.word_id = ? AND raw_synsets.definitions_ids @> ARRAY[?])', word, definition).
    order(:id)
end

def summarize(word)
  puts '# Определения "%s"' % word
  definitions(word).each do |definition|
    puts "\t%6d: %s (%s)" % [definition.id, definition.text, definition.source || 'н/д']
    examples(word, definition).each do |example|
      puts "\t\t%6d: %s (%s)" % [example.id, example.text, example.source || 'н/д']
    end
  end
  nil
end

def new_raw_synonomy(word1_id, word2_id, author_id)
  word1_id, word2_id = [word1_id, word2_id].sort! { |w1, w2| w1 <=> w2 }
  RawSynonymy.new do |r|
    r.word1_id = word1_id
    r.word2_id = word2_id
    r.author_id = author_id
  end
end

def new_raw_definition(word_id, definition_id, author_id)
  RawDefinition.new do |r|
    r.word_id = word_id
    r.definition_id = definition_id
    r.author_id = author_id
  end
end

def new_raw_example(raw_definition_id, example_id, author_id)
  RawExample.new do |r|
    r.raw_definition_id = raw_definition_id
    r.sample_id = example_id
    r.author_id = author_id
  end
end

RawSynonymy.delete_all
RawDefinition.delete_all
RawExample.delete_all

ActiveRecord::Base.connection.execute <<-END
  DROP INDEX IF EXISTS index_raw_synonymies_on_word1_id_and_word2_id CASCADE;
END

Word.find_in_batches do |group|
  Parallel.each(group, in_threads: 4) do |word|
    mputs '%5d: %s' % [word.id, word]
    next if word.word == '?'

    synonyms = synonyms(word)

    RawSynonymy.transaction do
      synonyms.each do |synonym|
        new_raw_synonomy(word.id, synonym.id, synonym.author_id || word.author_id).tap(&:save!)
      end
    end

    if rand > 0.7
      ActiveRecord::Base.connection.execute <<-END
        DELETE FROM raw_synonymies WHERE EXISTS (SELECT 'x' FROM raw_synonymies originals WHERE
          originals.word1_id = raw_synonymies.word1_id AND
          originals.word2_id = raw_synonymies.word2_id AND
          originals.id < raw_synonymies.id
        );
      END
    end

    definitions = definitions(word)

    RawDefinition.transaction do
      definitions.map! do |definition|
        new_raw_definition(word.id, definition.id, definition.author_id).tap(&:save!)
      end
    end

    definitions.each do |raw_definition|
      examples = examples(word, raw_definition.definition_id)

      RawExample.transaction do
        examples.map! do |example|
          new_raw_example(raw_definition.id, example.id, example.author_id).tap(&:save!)
        end
      end
    end
  end
end

ActiveRecord::Base.connection.execute <<-END
  DELETE FROM raw_synonymies WHERE EXISTS (SELECT 'x' FROM raw_synonymies originals WHERE
    originals.word1_id = raw_synonymies.word1_id AND
    originals.word2_id = raw_synonymies.word2_id AND
    originals.id < raw_synonymies.id
  );
END

ActiveRecord::Base.connection.execute <<-END
  CREATE UNIQUE INDEX index_raw_synonymies_on_word1_id_and_word2_id
  ON raw_synonymies
  USING btree
  (word1_id, word2_id);
END
