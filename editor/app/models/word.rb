class Word < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :word, :grammar, :accents, :uris

  serialize :accents, JSON
  serialize :uris, JSON

  before_save :update_revision

  def update_revision
    self.revision = (self.revision.presence || 0) + 1
    self.approver_id = self.approved_at = nil
  end
end
