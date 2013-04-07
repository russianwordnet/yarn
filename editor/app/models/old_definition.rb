class OldDefinition < ActiveRecord::Base
  self.table_name = 'definitions'

  belongs_to :origin, class_name: 'Definition', foreign_key: 'definition_id',
    :inverse_of => :old_definitions

  def self.from_definition(definition)
    old_definition = definition.old_definitions.build
    old_definition.text = definition.text
    old_definition.source = definition.source
    old_definition.uri = definition.uri
    old_definition.author_id = definition.author_id
    old_definition.approver_id = definition.approver_id
    old_definition.approved_at = definition.approved_at
    old_definition.revision = definition.revision
    old_definition.created_at = definition.updated_at
    return old_definition
  end
end
