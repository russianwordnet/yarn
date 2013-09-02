json.(@word, :id, :word)

json.definitions @definitions do |definition|
  json.id   definition.id
  json.text definition.text
  json.word @word.word
end

json.synonymes @synonymes do |synonym|
  json.id   synonym.id
  json.word synonym.word

  synsets     = synonym.raw_synset_words.map(&:synsets).flatten.uniq
  definitions = synsets.map(&:definitions).flatten.uniq

  json.definitions definitions do |definition|
    json.id   definition.id
    json.text definition.text
    json.word synonym.word
  end
end

json.synsets @synsets do |synset|
  json.id   synset.id
  json.text "Синсет №#{synset.id}"
end
