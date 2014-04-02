class Example < ActiveRecord::Base
  self.table_name = 'current_examples'

  attr_accessible :text, :source, :uri

  belongs_to :author, class_name: 'User'

  scope :find_by_raw_synset_words, ->(words_ids) {
    select("DISTINCT ON (id) current_examples.*").
    where("id IN (SELECT unnest(examples_ids) FROM raw_synset_words " \
          "WHERE id IN (?))", words_ids)
  }

  has_many :old_examples, -> { order 'revision' }, :inverse_of => :origin

  has_many :synset_words_examples
  has_many :synset_words, :through => :synset_words_examples

  has_many :synsets, :through => :synset_words
  has_many :words, :through => :synset_words

  has_one :raw_example, :foreign_key => :example_id

  def update_from(new_example)
    Example.transaction do
      old_examples.last and
      old_examples.last.created_at > 12.hours.ago and
      old_examples.last.author_id == new_example.author_id or
      OldExample.from_example(self).save!

      self.text = new_example.text
      self.source = new_example.source
      self.uri = new_example.uri
      self.author_id = new_example.author_id
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
