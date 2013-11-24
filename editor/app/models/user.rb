class User < ActiveRecord::Base
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

  def self.statistics(*users_ids)
    users_where = unless users_ids.empty?
      'WHERE united_synsets.author_id IN (?)'
    end

    find_by_sql([
      'SELECT united_synsets.author_id as id, name, count(*) AS score ' \
        'FROM (SELECT id, author_id FROM current_synsets UNION ALL ' \
              'SELECT synset_id AS id, author_id FROM synsets) AS ' \
      'united_synsets INNER JOIN users ON author_id = users.id ' \
      "#{users_where} GROUP BY author_id, name ORDER BY score DESC",
      users_ids
    ])
  end

  def to_s
    name
  end

  def admin?
    role && role.casecmp('admin')
  end
end
