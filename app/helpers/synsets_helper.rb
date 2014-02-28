module SynsetsHelper
  def synset_words(synset)
    synset.words.map(&:word).delete_if(&:deleted_at).map(&:word).join ', '
  end
end
