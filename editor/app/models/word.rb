class Word < ActiveRecord::Base
  self.table_name = 'current_words'

  paginates_per 150

  attr_accessible :word, :grammar, :accents, :uris, :frequency

  belongs_to :author, class_name: 'User'
  belongs_to :approver, class_name: 'User'

  has_many :old_words, order: 'revision DESC', :inverse_of => :origin

  has_many :synset_words
  has_many :raw_synset_words

  def self.next_word(id)
    find_by_sql([
      "SELECT * FROM #{table_name} ORDER BY frequency DESC OFFSET (" \
        'SELECT position FROM (' \
          'SELECT id, row_number() OVER () AS position ' \
            "FROM #{table_name} ORDER BY frequency DESC" \
        ') AS ordered_words WHERE id = ?' \
      ') LIMIT 1', id
    ]).first
  end

  def update_from(new_word)
    Word.transaction do
      old_words.last and
      old_words.last.created_at > 12.hours.ago and
      old_words.last.author == new_word.author_id or
      OldWord.from_word(self).save!

      self.word = new_word.word
      self.grammar = new_word.grammar
      self.accents = new_word.accents
      self.uris = new_word.uris
      self.author_id = new_word.author_id
      self.approver_id = new_word.approver_id
      self.approved_at = new_word.approved_at
      self.revision += 1

      return save.tap { |saved| old_word.save! if saved }
    end
  end  

  validates :word, presence: true

  def to_s
    word
  end

  def approved?
    approved_at && approver
  end
end
