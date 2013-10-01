class Definition < ActiveRecord::Base
  self.table_name = 'current_definitions'

  attr_accessible :text, :source, :uri

  belongs_to :author, class_name: 'User'

  has_many :old_definitions, :order => :revision,
    :inverse_of => :origin

  has_many :synsets, :inverse_of => :definitions, finder_sql: proc {
    %Q{SELECT * FROM current_synsets WHERE definitions_ids @> '{#{id}}';} }

  has_many :raw_synsets, :inverse_of => :definitions, finder_sql: proc {
    %Q{SELECT * FROM raw_synsets WHERE definitions_ids @> '{#{id}}';} }

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

  def to_s
    text
  end
end
