json.id @synset.id

json.words @synset.words do |synset_word|
  json.id   synset_word.word.id
  json.word synset_word.word.word
end

json.definitions @synset.definitions do |definition|
  json.id   definition.id
  json.text definition.text
end
