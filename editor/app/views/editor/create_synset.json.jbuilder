json.id @synset.id

json.words @synset.words do |synset_word|
  json.id   synset_word.word.id
  json.word synset_word.word.word
end

json.definitions []

json.synsets @synsets do |synset|
  json.id   synset.id
  json.text "Синсет №#{synset.id}"
end
