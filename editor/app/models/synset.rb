class Synset < ActiveRecord::Base
  self.table_name = 'current_synsets'

  paginates_per 70

  attr_accessible :words_ids, :definitions_ids

  belongs_to :author, class_name: 'User'
  belongs_to :approver, class_name: 'User'

  belongs_to :default_definition, class_name: 'Definition'
  belongs_to :default_synset_word, class_name: 'SynsetWord'

  before_save do |synset|
    unless synset.definitions_ids.include? synset.default_definition_id
      synset.default_definition_id = nil
    end

    unless synset.words_ids.include? synset.default_synset_word_id
      synset.default_synset_word_id = nil
    end
  end

  has_many :old_synsets, :order => :revision,
    :inverse_of => :origin

  has_many :definitions, finder_sql: proc {
    %Q{SELECT * FROM current_definitions WHERE id IN
        (SELECT unnest(definitions_ids) FROM current_synsets
          WHERE id = #{id});} }

  has_many :words, finder_sql: proc {
    %Q{SELECT * FROM current_synset_words WHERE id IN
        (SELECT unnest(words_ids) FROM current_synsets
          WHERE id = #{id});} }, class_name: 'SynsetWord'

  has_many :lexemes, class_name: 'Word', finder_sql: proc {
    %Q{SELECT * FROM current_words INNER JOIN
        (SELECT word_id FROM current_synset_words WHERE id IN
          (SELECT unnest(words_ids) FROM current_synsets
            WHERE id = #{id})) AS nested_synset_words
        ON nested_synset_words.word_id = current_words.id} }

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

  def update_from(new_synset, save_method = :save)
    Synset.transaction do
      # TODO - вынести в отдельный метод
      old_synsets.last and
      old_synsets.last.created_at > 12.hours.ago and
      old_synsets.last.author_id == new_synset.author_id or
      OldSynset.from_synset(self).save!

      self.words_ids = new_synset.words_ids
      self.definitions_ids = new_synset.definitions_ids
      self.author_id = new_synset.author_id
      self.revision += 1

      method(save_method).call.tap { |result| self.reload if result }
    end
  end

  def words_with_default_first
    return words_without_default_first unless default_synset_word_id
    words = words_without_default_first.dup

    words.delete(default_synset_word)
    words.prepend(default_synset_word)
  end
  alias_method_chain :words, :default_first

  def definitions_with_default_first
    return definitions_without_default_first unless default_definition_id
    definitions = definitions_without_default_first.dup

    definitions.delete(default_definition)
    definitions.prepend(default_definition)
  end
  alias_method_chain :definitions, :default_first

  def destroy
    update_from(self)
    update_attribute(:deleted_at, Time.now.utc)
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
