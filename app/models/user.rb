class User < ActiveRecord::Base
  has_merit

  devise :omniauthable

  attr_accessible :name, :provider, :uid

  has_many :words, :foreign_key => :author_id
  has_many :synsets, :foreign_key => :author_id
  has_many :synset_words, :foreign_key => :author_id
  has_many :samples, :foreign_key => :author_id
  has_many :definitions, :foreign_key => :author_id
  has_many :antonomy_relations, :foreign_key => :author_id
  has_many :synset_relations, :foreign_key => :author_id
  has_many :word_relations, :foreign_key => :author_id
  has_many :interlinks, :foreign_key => :author_id

  validates :name, presence: true

  scope :scores, ->(*users_ids) {
    select(['users.*', 'united_synsets.author_id AS id', 'count(*) AS score']).
    from('(SELECT id, author_id FROM current_synsets UNION ALL ' \
          'SELECT synset_id AS id, author_id FROM synsets) AS ' \
          'united_synsets').
    joins('INNER JOIN users ON author_id = users.id').
    where(users_ids.any? && 'united_synsets.author_id IN (?)', users_ids).
    group(:author_id, :name, 'users.id').
    order('score DESC')
  }

  def to_s
    name
  end

  def admin?
    role && role.casecmp('admin') == 0
  end
end
