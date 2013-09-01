class RawSynset < ActiveRecord::Base
  attr_accessible :words_ids, :definitions_ids

  belongs_to :author, class_name: 'User'

  has_many :definitions, finder_sql: proc {
    %Q{SELECT * FROM current_definitions WHERE id IN
        (SELECT unnest(definitions_ids) FROM raw_synsets
          WHERE id = #{id});} }

  has_many :words, finder_sql: proc {
    %Q{SELECT * FROM raw_synset_words WHERE id IN
        (SELECT unnest(words_ids) FROM raw_synsets
          WHERE id = #{id});} }, class_name: 'RawSynsetWord'
end
