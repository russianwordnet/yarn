json.(@word, :id, :word)

json.synonymes @raw_synonyms do |synonym|
  json.word_id synonym.id
  json.word    synonym.word

  json.definitions @synonyms_definitions[synonym.id] do |definition|
    json.id      definition.id
    json.text    definition.text
    json.word_id synonym.id
    json.word    synonym.word
    json.source definition.source.presence
    json.samples @samples[definition.id] do |sample|
      json.id   sample[:id]
      json.text sample[:text]
    end
  end
end

json.synsets @synsets do |synset|
  json.id   synset.id
  if (synset_words = synset.words_with_default_first).any?
    json.text synset_words.uniq(&:word_id).map(&:word).map(&:word).join ', '
  else
    json.text "Пустой синсет №#{synset.id}"
  end
  json.first_definition synset.default_definition ? synset.default_definition.try(:text) : synset.definitions.first.try(:text)
  json.state synset.state(current_user)
end
