class CreateCurrentSynsetWordsMarks < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE OR REPLACE VIEW current_synset_words_marks AS 
       SELECT current_synset_words.id AS synset_word_id,
          unnest(current_synset_words.marks_ids) AS mark_id
         FROM current_synset_words;
    SQL
  end

  def down
    execute 'DROP VIEW current_synset_words_marks;'
  end
end
