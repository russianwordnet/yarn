class RawSynsetWord < ActiveRecord::Base
  attr_accessible :word, :samples_ids, :nsg, :marks

  belongs_to :author, class_name: 'User'

  belongs_to :word, :inverse_of => :synset_words

  scope :find_by_content, ->(definitions_ids, word_id) {
    select("DISTINCT ON (id) raw_synset_words.*").
    joins("INNER JOIN raw_synsets ON ARRAY[raw_synset_words.id] " \
          "&& raw_synsets.words_ids").
    where("word_id = ? AND definitions_ids @> '{?}'", word_id, definitions_ids)
  }

  has_many :synsets, finder_sql: proc {
    %Q{SELECT * FROM raw_synsets WHERE words_ids @> '{#{id}}';} },
    class_name: 'RawSynset'

  has_many :samples, finder_sql: proc {
    %Q{SELECT * FROM current_samples WHERE id IN
        (SELECT unnest(samples_ids) FROM raw_synset_words
          WHERE id = #{id});} },
    class_name: 'Sample'
end
