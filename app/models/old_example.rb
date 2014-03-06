class OldExample < ActiveRecord::Base
  self.table_name = 'examples'

  belongs_to :author, class_name: 'User'
  belongs_to :origin, class_name: 'Example', foreign_key: 'example_id',
    :inverse_of => :old_examples

  def self.from_example(example)
    old_example = example.old_examples.build
    old_example.text = example.text
    old_example.source = example.source
    old_example.uri = example.uri
    old_example.author_id = example.author_id
    old_example.approver_id = example.approver_id
    old_example.approved_at = example.approved_at
    old_example.revision = example.revision
    old_example.created_at = example.updated_at
    return old_example
  end
end
