module SynsetsHelper
  def synset_words(synset)
    synset.words.map(&:word).map(&:word).join ', '
  end
end
