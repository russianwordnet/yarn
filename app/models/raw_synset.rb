class RawSynset < ActiveRecord::Base
  attr_accessible :words_ids, :definitions_ids

  belongs_to :author, class_name: 'User'

  def self.find_by_content(definition_id, word_id)
    select("DISTINCT ON (id) raw_synsets.*").
    where("definitions_ids @> '{?}' AND " \
          "(SELECT array_agg(id) FROM raw_synset_words WHERE word_id = ?) " \
          "&& words_ids", definition_id, word_id).
    limit(1).
    first
  end
end
