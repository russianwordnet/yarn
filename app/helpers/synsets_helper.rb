module SynsetsHelper
  def synset_words(synset)
    synset.lexemes.
      where(current_words: { deleted_at: nil },
            current_synset_words: { deleted_at: nil }).
      map(&:word).
      join(', ')
  end
end
