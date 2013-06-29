module SynsetsHelper
  def synset_words(synset)
    joined = synset.words.map(&:word).map(&:word).join ', '
    "(#{joined})"
  end
end