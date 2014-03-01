module Yarn::Raw
  class ExampleSAX
    include SAXMachine
    attribute :source
    attribute :url
    element :text
  end

  class DefinitionSAX
    include SAXMachine
    attribute :source
    attribute :url
    element :text
    elements :mark, :as => :marks
    elements :example, :as => :examples, class: ExampleSAX
  end

  class LexicalEntrySAX
    include SAXMachine
    attribute :id
    attribute :word
    attribute :grammar
    elements :accent, :as => :accents
    elements :url, :as => :urls
    elements :definition, :as => :definitions, class: DefinitionSAX
  end

  class LexiconSAX
    include SAXMachine
    elements :entry, :as => :entries, class: LexicalEntrySAX
  end

  class SAX
    include SAXMachine
    element :lexicon, class: LexiconSAX
  end
end
