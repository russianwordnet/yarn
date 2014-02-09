class Sample < ActiveRecord::Base
  self.table_name = 'current_samples'

  attr_accessible :text, :source, :uri

  belongs_to :author, class_name: 'User'

  scope :find_by_raw_synset_words, ->(words_ids) {
    select("DISTINCT ON (id) current_samples.*").
    where("id IN (SELECT unnest(samples_ids) FROM raw_synset_words " \
          "WHERE id IN (?))", words_ids)
  }

  has_many :old_samples, :order => :revision,
    :inverse_of => :origin

  has_many :synset_words, finder_sql: proc {
    %Q{SELECT * FROM current_synset_words WHERE samples_ids @> '{#{id}}';} }

  has_many :raw_synset_words, finder_sql: proc {
    %Q{SELECT * FROM raw_synset_words WHERE samples_ids @> '{#{id}}';} },
    class_name: 'RawSynsetWord'

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

  def text
    attributes['text'].try(:bbcode_to_html, {}, false, :enable,
      :bold, :italics, :underline).try(:html_safe)
  end

  def to_s
    text
  end
end
