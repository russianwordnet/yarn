class Synset < ActiveRecord::Base
  self.table_name = 'current_synsets'

  include Yarn::Trackable::Head

  paginates_per 70

  attr_accessible :words_ids, :default_definition_id, :default_synset_word_id

  belongs_to :author, class_name: 'User'
  belongs_to :approver, class_name: 'User'

  belongs_to :default_definition, class_name: 'Definition'
  accepts_nested_attributes_for :default_definition

  belongs_to :default_synset_word, class_name: 'SynsetWord'
  has_one :default_word, :through => :default_synset_word, :source => :word

  before_save do |synset|
    unless synset.words_ids.include? synset.default_synset_word_id
      synset.default_synset_word_id = nil
    end
  end

  def words_with_default_first
    result = words.includes(:word).to_a.sort { |sw1, sw2| sw1.word.word <=> sw2.word.word }
    return result unless default_synset_word_id

    result.delete(default_synset_word)
    result.prepend(default_synset_word)
  end

  has_many :synsets_synonyms
  has_many :words, :through => :synsets_synonyms, :source => :synset_word, class_name: 'SynsetWord'

  has_many :lexemes, class_name: 'Word', :through => :words, :source => :word
  has_many :definitions, :through => :words

  has_many :antonomy_relations
  has_many :synset_relations
  has_many :interlinks, class_name: 'SynsetInterlink'

  has_one  :synset_domain
  has_one  :domain, :through => :synset_domain

  scope :with_initiators, -> {
    select('current_synsets.*',
           'first_value(COALESCE(synsets.author_id, current_synsets.author_id)) OVER ('\
             'PARTITION BY current_synsets.id ' \
             'ORDER BY synsets.revision' \
           ') AS initiator_id').
    joins('LEFT JOIN synsets ON synsets.synset_id = current_synsets.id').
    uniq
  }

  scope :joins_initiators, -> {
    joins('INNER JOIN (%s) AS "current_synsets_initiators" ON ' \
          '"current_synsets_initiators"."id" = "current_synsets"."id"' % with_initiators.to_sql)
  }

  def self.retrieve_creators
    synsets = with_initiators.where(deleted_at: nil).order(:updated_at).reverse
    users = User.find(synsets.map(&:initiator_id)).group_by(&:id)
    synsets.group_by { |s| users[s.initiator_id].first }.
      sort { |(_, s1), (_, s2)| s2.size <=> s1.size }
  end

  def destroy
    update_with_tracking { |s| s.deleted_at = Time.now.utc }
  end

  def origin_author
    return author if revision == 1

    old_synsets.find_by_revision(1).author
  end

  def allow_destroy_by?(user)
    user.admin? || origin_author.id == user.id
  end

  def open_for_user?(user)
    return false if (updated_at > 5.minutes.ago) && (user.id != author_id)
    return false if words_ids && SynsetWord.where(id: words_ids).where(%Q{author_id != #{user.id} and updated_at > '#{5.minutes.ago}'}).exists?

    true
  end

  # TODO: State machine
  def state(user = nil)
    return :approved if approved_at.present?
    return :closed if user && !open_for_user?(user)

    :normal
  end
end
