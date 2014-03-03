#!/usr/bin/env ruby
# encoding: utf-8

$semaphore = Mutex.new

def mputs(*args)
  $semaphore.synchronize { puts(*args) }
end

Synset.find_in_batches do |group|
  Parallel.each(group, in_threads: 4) do |synset|
    mputs(synset.inspect)

    definitions = synset.definitions.group_by do |definition|
      if raw_definition = definition.raw_definition
        raw_definition.word_id
      end
    end

    synset.words.each do |synset_word|
      next unless word_definitions = definitions.delete(synset_word.word_id)
      
      synset_word.update_with_tracking({}, :save!) do |synset_word|
        synset_word.definitions_ids += word_definitions.map(&:id)
        synset_word.definitions_ids = synset_word.definitions_ids.uniq
      end
    end

    # synset.definitions_ids = definitions.values.flatten.uniq.map(&:id)

    synset.update_with_tracking({}, :save!) do |synset|
      synset.definitions_ids = definitions.values.flatten.uniq.map(&:id)
    end

    unless synset.definitions_ids.empty?
      mputs('Residuals in %d: %s' % [synset.id, synset.definitions_ids.inspect])
    end
  end
end
