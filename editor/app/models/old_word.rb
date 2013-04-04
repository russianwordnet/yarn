class OldWord < ActiveRecord::Base
  self.table_name = 'words'
  # self.primary_keys = 'word_id', 'version'

  attr_accessible :word, :grammar, :accents, :uris, :author_id,
    :approver_id, :approved_at, :created_at, :deleted_at

  belongs_to :origin, class_name: 'Word', foreign_key: 'word_id',
    :inverse_of => :old_words

  serialize :accents, JSON
  serialize :uris, JSON

  def self.from_word(word)
    old_word = word.old_words.build
    old_word.word = word.word
    old_word.grammar = word.grammar
    old_word.accents = word.accents
    old_word.uris = word.uris
    old_word.author_id = word.author_id
    old_word.approver_id = word.approver_id
    old_word.approved_at = word.approved_at
    old_word.created_at = word.updated_at
    return old_word
  end
end
