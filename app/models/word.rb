# encoding: utf-8
class Word < ActiveRecord::Base
  self.table_name = 'current_words'

  include Yarn::Trackable::Head

  paginates_per 150

  attr_accessible :word, :grammar, :accents, :uris, :frequency

  belongs_to :author, class_name: 'User'
  belongs_to :approver, class_name: 'User'
  has_one :score, class_name: 'WordScore'

  has_many :old_words, -> { order 'revision DESC' }, :inverse_of => :origin

  has_many :synset_words
  has_many :raw_synset_words

  has_many :antonomy_relations
  has_many :word_relations

  has_many :synsets, :through => :synset_words
  has_many :definitions, :through => :synset_words
  has_many :examples, :through => :synset_words

  has_many :raw_synonym, :inverse_of => :word1, :foreign_key => :word1_id
  has_many :raw_synonyms, :through => :raw_synonym, :source => :word2

  scope :search, ->(query) {
    tokens = query.to_s.split
    regexps = tokens.map { |w| Regexp.escape(w).gsub(/[ЕеЁё]/, '[ЕеЁё]') }
    bregexps = regexps.map { |r| "(word ~* '\\m%s')::integer" % r }
    select(['%s.*' % table_name, '%s AS rank' % bregexps.join(' + ')]).
    where(regexps.map { |r| "word ~* '%s'" % r }.join(' AND '))
  }

  scope :next_word, ->(id) {
    joins('JOIN (SELECT *, lead(id, 1) OVER (ORDER BY score DESC) AS next_word_id FROM current_words ' \
          'JOIN current_words_scores ON current_words_scores.word_id = current_words.id ' \
          'WHERE id = %1$d OR deleted_at IS NULL) AS ordered_words ON ordered_words.id = %1$d' % id).
    where('current_words.id = ordered_words.next_word_id').
    first
  }

  def update_from(new_word, save_method = :save)
    Word.transaction do
      old_words.last and
      old_words.last.created_at > 12.hours.ago and
      old_words.last.author_id == new_word.author_id or
      OldWord.from_word(self).save!

      self.word = new_word.word
      self.grammar = new_word.grammar
      self.accents = new_word.accents
      self.frequency = new_word.frequency
      self.uris = new_word.uris
      self.author_id = new_word.author_id
      self.approver_id = new_word.approver_id
      self.approved_at = new_word.approved_at
      self.revision += 1

      method(save_method).call.tap { |result| self.reload if result }
    end
  end  

  validates :word, presence: true

  def to_s
    word
  end

  def approved?
    approved_at && approver
  end

  def destroy
    update_with_tracking { |s| s.deleted_at = Time.now.utc }
  end
end
