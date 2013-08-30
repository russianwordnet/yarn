class RawSynsetWord < ActiveRecord::Base
  attr_accessible :word, :samples_ids, :nsg, :marks

  belongs_to :author, class_name: 'User'

  belongs_to :word, :inverse_of => :synset_words

  has_many :synsets, :inverse_of => :words, finder_sql: proc {
    %Q{SELECT * FROM raw_synsets WHERE words_ids @> '{#{id}}';} },
    class_name: 'RawSynset'

  has_many :samples, :inverse_of => :synset_words, finder_sql: proc {
    %Q{SELECT * FROM raw_samples WHERE id IN
        (SELECT unnest(samples_ids) FROM raw_synset_words
          WHERE id = #{id});} },
    class_name: 'RawSample'
end
