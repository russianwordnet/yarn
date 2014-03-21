class Definition < ActiveRecord::Base
  self.table_name = 'current_definitions'

  include Yarn::Trackable::Head

  attr_accessible :text, :source, :uri

  belongs_to :author, class_name: 'User'

  has_many :old_definitions, -> { order 'revision '}, :inverse_of => :origin

  has_and_belongs_to_many :synset_words,
    join_table: 'current_synset_words_definitions'

  has_many :synsets, :through => :synset_words

  has_one :raw_definition

  def update_from(new_definition)
    Definition.transaction do
      old_definitions.last and
      old_definitions.last.created_at > 12.hours.ago and
      old_definitions.last.author_id == new_definition.author_id or
      OldDefinition.from_definition(self).save!

      self.text = new_definition.text
      self.source = new_definition.source
      self.uri = new_definition.uri
      self.author_id = new_definition.author_id
      self.revision += 1

      save
    end
  end

  def text
    attributes['text'].try(:bbcode_to_html, {}, false, :enable,
      :bold, :italics, :underline).try(:html_safe)
  end

  def to_s
    text
  end
end
