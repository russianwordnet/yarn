# encoding: utf-8

class WordEntrySAX
  include SAXMachine
  attribute :id
  element :word
  element :grammar
  elements :url, :as => :uris
  elements :accent, :as => :accents
end

class WordsSAX
  include SAXMachine
  elements :wordEntry, :as => :entries, class: WordEntrySAX
end

class SampleSAX
  include SAXMachine
  attribute :source
  attribute :url, :as => :uri
  value :text
end

class SynsetWordSAX
  include SAXMachine
  attribute :ref
  attribute :nonStandardGrammar, :as => :nsg
  elements :sample, :as => :samples, class: SampleSAX
  elements :mark, :as => :marks
end

class DefinitionSAX
  include SAXMachine
  attribute :source
  attribute :url, :as => :uri
  value :text
end

class SynsetEntrySAX
  include SAXMachine
  attribute :id
  elements :word, :as => :words, class: SynsetWordSAX
  elements :definition, :as => :definitions, class: DefinitionSAX
end

class SynsetsSAX
  include SAXMachine
  elements :synsetEntry, :as => :entries, class: SynsetEntrySAX
end

class SynsetRelationEntrySAX
  include SAXMachine
  attribute :id
  attribute :synset1, :as => :synset1_id
  attribute :synset2, :as => :synset2_id
  attribute :type
end

class SynsetRelationsSAX
  include SAXMachine
  elements :synsetRelations, :as => :relations, class: SynsetRelationEntrySAX
end

class WordRelationEntrySAX
  include SAXMachine
  attribute :id
  attribute :word1, :as => :word1_id
  attribute :word2, :as => :word2_id
  attribute :type
end

class WordRelationsSAX
  include SAXMachine
  elements :wordRelations, :as => :relations, class: WordRelationEntrySAX
end

class AntonomyRelationEntrySAX
  include SAXMachine
  attribute :id
  attribute :synset1, :as => :synset1_id
  attribute :synset2, :as => :synset2_id
  attribute :word1, :as => :word1_id
  attribute :word2, :as => :word2_id
  attribute :type
end

class AntonomyRelationsSAX
  include SAXMachine
  elements :antonymyRelations, :as => :relations, class: AntonomyRelationEntrySAX
end

class InterlinkEntrySAX
  include SAXMachine
  attribute :id
  attribute :YARNSynset, :as => :synset_id
  attribute :PWNSynset, :as => :pwn
end

class YarnSAX
  include SAXMachine
  element :words, class: WordsSAX
  element :synsets, class: SynsetsSAX
  element :synset_relations, class: SynsetRelationsSAX
  element :word_relations, class: WordRelationsSAX
  element :antonomy_relations, class: AntonomyRelationsSAX
end
