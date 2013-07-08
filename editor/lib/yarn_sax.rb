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

class YarnSAX
  include SAXMachine
  element :words, class: WordsSAX
  element :synsets, class: SynsetsSAX
end
