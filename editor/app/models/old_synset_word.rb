class OldSynsetWord < ActiveRecord::Base
  self.table_name = 'synset_words'

  attr_accessible :word, :nsg, :marks_ids, :samples

  belongs_to :word

  belongs_to :author, class_name: 'User'
  belongs_to :origin, class_name: 'SynsetWord', foreign_key: 'synset_word_id',
    :inverse_of => :old_synset_words

  def self.from_synset_word(synset_word)
    old_synset_word = synset_word.old_synset_words.build
    old_synset_word.word = synset_word.word
    old_synset_word.nsg = synset_word.nsg
    old_synset_word.marks = synset_word.marks
    old_synset_word.samples_ids = synset_word.samples_ids
    old_synset_word.author_id = synset_word.author_id
    old_synset_word.approver_id = synset_word.approver_id
    old_synset_word.approved_at = synset_word.approved_at
    old_synset_word.revision = synset_word.revision
    old_synset_word.created_at = synset_word.updated_at
    return old_synset_word
  end
end
