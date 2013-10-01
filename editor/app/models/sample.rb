class Sample < ActiveRecord::Base
  self.table_name = 'current_samples'

  attr_accessible :text, :source, :uri

  belongs_to :author, class_name: 'User'

  has_many :old_samples, :order => :revision,
    :inverse_of => :origin

  has_many :synset_words, finder_sql: proc {
    %Q{SELECT * FROM current_synset_words WHERE samples_ids @> '{#{id}}';} }

  def update_from(new_sample)
    Sample.transaction do
      old_samples.last and
      old_samples.last.created_at > 12.hours.ago and
      old_samples.last.author_id == new_sample.author_id or
      OldSample.from_sample(self).save!

      self.text = new_sample.text
      self.source = new_sample.source
      self.uri = new_sample.uri
      self.author_id = new_sample.author_id
      self.revision += 1

      save
    end
  end
end
