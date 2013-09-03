json.id @synset.id

json.words @synset.words do |synset_word|
  json.id   synset_word.word.id
  json.word synset_word.word.word
end

json.definitions @synset.definitions do |definition|
  json.id   definition.id
  json.text definition.text
end

json.synsets @synsets do |synset|
  json.id   synset.id
  if synset.words.any?
    json.text synset.words.map(&:word).uniq.map(&:word).join ', '
  else
    json.text "Пустой синсет №#{synset.id}"
  end
end
