json.(@word, :id, :word)

json.definitions @definitions do |definition|
  json.id   definition.id
  json.text definition.text
  json.word_id @word.id
  json.word    @word.word
  json.samples @samples[definition.id] do |sample|
    json.id   sample[:id]
    json.text sample[:text]
  end
end

json.synonymes @raw_synonyms do |synonym|
  json.word_id synonym.id
  json.word    synonym.word

  json.definitions @synonyms_definitions[synonym.id] do |definition|
    json.id      definition.id
    json.text    definition.text
    json.word_id synonym.id
    json.word    synonym.word
    json.samples @samples[definition.id] do |sample|
      json.id   sample[:id]
      json.text sample[:text]
    end
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
  json.state synset.state(current_user)
end
