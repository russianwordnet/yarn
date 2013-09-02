json.(@synset, :id)

json.synsets @synsets do |synset|
  json.id   synset.id
  json.text "Синсет №#{synset.id}"
end
