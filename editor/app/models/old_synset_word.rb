class OldSynsetWord < ActiveRecord::Base
  self.table_name = 'synset_words'

  attr_accessible :word, :nsg, :marks_ids, :samples

  belongs_to :word

  belongs_to :author, class_name: 'User'
  belongs_to :origin, class_name: 'SynsetWord', foreign_key: 'synset_word_id',
    :inverse_of => :old_synset_words

   def self.from_synset_word(synset_word)
    attrs = synset_word.attributes.reject {|k,_| %w(id updated_at).include? k }
    attrs.merge!(created_at: synset_word.updated_at)

    old_synset_word = synset_word.old_synset_words.build(attrs, without_protection: true)

    old_synset_word
   end
end
