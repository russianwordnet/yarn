class RawSample < ActiveRecord::Base
  attr_accessible :text, :source, :uri

  belongs_to :author, class_name: 'User'

  has_many :synset_words, finder_sql: proc {
    %Q{SELECT * FROM raw_synset_words WHERE samples_ids @> '{#{id}}';} },
    class_name: 'RawSynsetWord'
end
