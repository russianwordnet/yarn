class RawSample < ActiveRecord::Base
  attr_accessible :text, :source, :uri

  belongs_to :author, class_name: 'User'

  scope :find_by_synset_words, ->(words_ids) {
    select("DISTINCT(raw_samples.id)").
    where("id IN (SELECT unnest(samples_ids) FROM raw_synset_words " \
          "WHERE id IN (?))", words_ids)
  }

  has_many :synset_words, finder_sql: proc {
    %Q{SELECT * FROM raw_synset_words WHERE samples_ids @> '{#{id}}';} },
    class_name: 'RawSynsetWord'
end
