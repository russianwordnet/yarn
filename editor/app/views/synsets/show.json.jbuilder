json.id @synset.id

json.words @synset.words do |synset_word|
  json.id   synset_word.word.id
  json.word synset_word.word.word
end

json.definitions @synset.definitions do |definition|
  json.id   definition.id
  json.text definition.text
end

json.selected_synset do
  json.id @synset.id
  if (synset_words = @synset.words.to_a).any?
    json.text synset_words.uniq(&:word_id).map(&:word).map(&:word).join ', '
  else
    json.text "Пустой синсет №#{@synset.id}"
  end
  json.first_definition @synset.definitions.first.try(:text)
end
