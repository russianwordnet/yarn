class Word < ActiveRecord::Base
  self.table_name = 'current_words'

  paginates_per 150

  attr_accessible :word, :grammar, :accents, :uris, :frequency

  belongs_to :author, class_name: 'User'
  belongs_to :approver, class_name: 'User'
  has_one :score, class_name: 'WordScore'

  has_many :old_words, order: 'revision DESC', :inverse_of => :origin

  has_many :synset_words
  has_many :raw_synset_words

  has_many :antonomy_relations
  has_many :word_relations

  has_many :raw_synonym, :inverse_of => :word1, :foreign_key => :word1_id
  has_many :raw_synonyms, :through => :raw_synonym, :source => :word2

  scope :search, ->(query) {
    tsquery = sanitize(query.to_s)
    regexp = sanitize('.*%s.*' % Regexp.escape(query.to_s).
      gsub(/[ЕеЁё]/, '[ЕеЁё]'))

    select(['%s.*' % table_name, "ts_rank(to_tsvector('russian', word), query) AS rank"]).
    from("%s, plainto_tsquery('russian', %s) query" % [table_name, tsquery]).
    where("(to_tsvector('russian', word) @@ query OR word ~* %s)" % regexp)
  }

  # TODO: scope!
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
end
