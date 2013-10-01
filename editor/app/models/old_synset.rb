class OldSynset < ActiveRecord::Base
  self.table_name = 'synsets'

  attr_accessible :words, :definitions

  belongs_to :author, class_name: 'User'
  belongs_to :origin, class_name: 'Synset', foreign_key: 'synset_id',
    :inverse_of => :old_synsets

  def self.from_synset(synset)
    old_synset = synset.old_synsets.build
    old_synset.words_ids = synset.words_ids
    old_synset.definitions_ids = synset.definitions_ids
    old_synset.author_id = synset.author_id
    old_synset.approver_id = synset.approver_id
    old_synset.approved_at = synset.approved_at
    old_synset.revision = synset.revision
    old_synset.created_at = synset.updated_at
    return old_synset
  end
end
