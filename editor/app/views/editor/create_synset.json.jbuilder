json.id @synset.id

json.words @synset.words do |synset_word|
  json.id               synset_word.word.id
  json.synset_word_id   synset_word.id
  json.word             synset_word.word.word
  json.marks  synset_word.marks do |mark|
    json.id   mark.id
    json.name mark.name
  end
  json.samples synset_word.samples do |sample|
    json.text sample.text
  end
end

json.definitions @synset.definitions do |definition|
  json.id   definition.id
  json.text definition.text
end

json.synsets @synsets do |synset|
  json.id   synset.id
  if (synset_words = synset.words.to_a).any?
    json.text synset_words.uniq(&:word_id).map(&:word).map(&:word).join ', '
  else
    json.text "Пустой синсет №#{synset.id}"
  end

  json.first_definition synset.default_definition ? synset.default_definition.try(:text) : synset.definitions.first.try(:text)
end

json.selected_synset do
  json.id @synset.id
  if (synset_words = @synset.words.to_a).any?
    json.text synset_words.uniq(&:word_id).map(&:word).map(&:word).join ', '
  else
    json.text "Пустой синсет №#{@synset.id}"
  end

  json.first_definition @synset.default_definition ? @synset.default_definition.try(:text) : @synset.definitions.first.try(:text)
end