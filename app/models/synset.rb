class Synset < ActiveRecord::Base
  self.table_name = 'current_synsets'

  include Yarn::Trackable::Head

  paginates_per 70

  attr_accessible :words_ids, :default_definition_id, :default_synset_word_id

  belongs_to :author, class_name: 'User'
  belongs_to :approver, class_name: 'User'

  belongs_to :default_definition, class_name: 'Definition'
  belongs_to :default_synset_word, class_name: 'SynsetWord'

  before_save do |synset|
    unless synset.words_ids.include? synset.default_synset_word_id
      synset.default_synset_word_id = nil
    end
  end

  has_and_belongs_to_many :words, class_name: 'SynsetWord',
    join_table: 'current_synsets_synonyms'

  has_many :lexemes, class_name: 'Word', :through => :words, :source => :word
  has_many :definitions, :through => :words

  has_many :antonomy_relations
  has_many :synset_relations
  has_many :interlinks

  def self.retrieve_creators
    find_by_sql('SELECT ranked_synsets.id, ranked_synsets.author_id FROM ' \
      '(SELECT synsets.*, rank() OVER (' \
        'PARTITION BY synset_id ORDER BY synsets.revision' \
      ') AS rank FROM synsets) AS ranked_synsets ' \
      'INNER JOIN current_synsets ON synset_id = current_synsets.id ' \
      'WHERE array_length(current_synsets.words_ids, 1) > 1 ' \
      'AND rank = 1 AND current_synsets.deleted_at IS NULL').
    group_by(&:author).
    sort { |(_, s1), (_, s2)| s2.size <=> s1.size }
  end

  def words_with_default_first
    return words_without_default_first unless default_synset_word_id
    words = words_without_default_first.dup

    words.delete(default_synset_word)
    words.prepend(default_synset_word)
  end
  alias_method_chain :words, :default_first

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
