class OldSample < ActiveRecord::Base
  self.table_name = 'examples'

  belongs_to :author, class_name: 'User'
  belongs_to :origin, class_name: 'Sample', foreign_key: 'example_id',
    :inverse_of => :old_samples

  def self.from_sample(sample)
    old_sample = sample.old_samples.build
    old_sample.text = sample.text
    old_sample.source = sample.source
    old_sample.uri = sample.uri
    old_sample.author_id = sample.author_id
    old_sample.approver_id = sample.approver_id
    old_sample.approved_at = sample.approved_at
    old_sample.revision = sample.revision
    old_sample.created_at = sample.updated_at
    return old_sample
  end
end
