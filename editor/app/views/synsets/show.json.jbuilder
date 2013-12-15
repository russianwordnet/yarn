json.id @synset.id

json.words @synset_words do |synset_word|
  json.id               synset_word.word.id
  json.synset_word_id   synset_word.id
  json.word             synset_word.word.word
end

json.definitions @definitions do |definition|
  json.id   definition.id
  json.text definition.text
end

json.selected_synset do
  json.id @synset.id
  if @lexemes.size > 0
    json.text @lexemes.map(&:word).join ', '
  else
    json.text "Пустой синсет №#{@synset.id}"
  end
  json.first_definition  @synset.default_definition ? @synset.default_definition.try(:text) : @definitions.first.try(:text)
end
