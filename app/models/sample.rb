class Sample < ActiveRecord::Base
  self.table_name = 'current_examples'

  attr_accessible :text, :source, :uri

  belongs_to :author, class_name: 'User'

  scope :find_by_raw_synset_words, ->(words_ids) {
    select("DISTINCT ON (id) current_examples.*").
    where("id IN (SELECT unnest(examples_ids) FROM raw_synset_words " \
          "WHERE id IN (?))", words_ids)
  }

  has_many :old_samples, -> { order 'revision' }, :inverse_of => :origin

  has_and_belongs_to_many :synset_words, foreign_key: 'example_id',
    join_table: 'current_synset_words_examples'

  has_many :synsets, :through => :synset_words
  has_many :words, :through => :synset_words

  has_one :raw_example, :foreign_key => :example_id

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
