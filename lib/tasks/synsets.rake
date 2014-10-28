namespace :yarn do
  namespace :synsets do
    desc 'Make the most frequent words default for their non-empty synsets'
    task :default_words => :environment do
      Synset.transaction do
        relation = Synset.
          where(default_synset_word_id: nil).
          where('array_length(words_ids, 1) > 0').
          where(deleted_at: nil)

        relation.find_each do |synset|
          synset_words = synset.words.includes(:word).
            where(current_words: {deleted_at: nil}).
            where(deleted_at: nil)
          default_synset_word = synset_words.sort_by { |sw| sw.word.frequency }.last
          synset.update_attribute(:default_synset_word, default_synset_word)
        end
      end
    end
  end
end
