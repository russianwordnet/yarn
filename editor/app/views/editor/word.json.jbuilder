json.(@word, :id, :word)

json.definitions @definitions do |definition|
  json.id   definition.id
  json.text definition.text
  json.word_id @word.id
  json.word    @word.word
  json.samples @samples[definition.id]
end

json.synonymes @synset_words do |synset_word|
  json.word_id synset_word.word.id
  json.word    synset_word.word.word

  synsets     = synset_word.word.raw_synset_words.map(&:synsets).flatten.uniq
  definitions = synsets.map(&:definitions).flatten.uniq

  json.definitions definitions do |definition|
    json.id      definition.id
    json.text    definition.text
    json.word_id synset_word.word.id
    json.word    synset_word.word.word
  end
end

json.synsets @synsets do |synset|
  json.id   synset.id
  if (synset_words = synset.words.to_a).any?
    json.text synset_words.uniq(&:word_id).map(&:word).map(&:word).join ', '
  else
    json.text "Пустой синсет №#{synset.id}"
  end
  json.first_definition synset.default_definition ? synset.default_definition.try(:text) : synset.definitions.first.try(:text)
  json.state synset.approved_at.present? ? 'approved' : nil
end
