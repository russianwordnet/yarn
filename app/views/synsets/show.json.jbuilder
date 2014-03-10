json.id @synset.id
json.allow_destroy current_user && @synset.allow_destroy_by?(current_user)
json.allow_approve current_user && current_user.admin?
json.timestamp Time.now.to_f

json.words @synset_words do |synset_word|
  json.id               synset_word.word.id
  json.synset_word_id   synset_word.id
  json.word             synset_word.word.word
  json.marks  synset_word.marks do |mark|
    json.id   mark.id
    json.name mark.name
  end
  json.samples synset_word.samples do |sample|
    json.id   sample.id
    json.text sample.text
  end
  json.definitions synset_word.definitions do |definition|
    json.id   definition.id
    json.text definition.text
  end
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
