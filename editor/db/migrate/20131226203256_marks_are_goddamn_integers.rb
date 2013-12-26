class MarksAreGoddamnIntegers < ActiveRecord::Migration
  def up
    remove_index :current_synset_words, :name => :index_current_synset_words_on_marks
    remove_index :synset_words, :name => :index_synset_words_on_marks

    remove_column :current_synset_words, :marks
    remove_column :synset_words, :marks

    change_table :current_synset_words do |t|
      t.integer :marks_ids, array: true, default: [], null: false
    end

    change_table :synset_words do |t|
      t.integer :marks_ids, array: true, default: [], null: false
    end

    execute 'CREATE INDEX index_current_synset_words_on_marks_ids ON current_synset_words USING gin (marks_ids);'
    execute 'CREATE INDEX index_synset_words_on_marks_ids ON synset_words USING gin (marks_ids);'
  end

  def down
    remove_index :current_synset_words, :name => :index_current_synset_words_on_marks_ids
    remove_index :synset_words, :name => :index_synset_words_on_marks_ids

    remove_column :current_synset_words, :marks_ids
    remove_column :synset_words, :marks_ids

    change_table :current_synset_words do |t|
      t.string :marks, array: true, default: [], null: false
    end

    change_table :synset_words do |t|
      t.string :marks, array: true, default: [], null: false
    end

    execute 'CREATE INDEX index_current_synset_words_on_marks ON current_synset_words USING gin (marks);'
    execute 'CREATE INDEX index_synset_words_on_marks ON synset_words USING gin (marks);'
  end
end
