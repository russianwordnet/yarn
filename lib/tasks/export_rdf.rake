namespace :yarn do
  namespace :export do
    desc 'Export the thesaurus in the Turtle format to /public/yarn.rdf'
    task :rdf => :environment do
      include Rails.application.routes.url_helpers
      Rails.application.routes.default_url_options[:host] = 'russianword.net'

      uri = RDF::URI('http://russianword.net/')

      graph = RDF::Graph.new

      graph << [uri, RDF.type, RDF::Lemon.Lexicon]
      graph << [uri, RDF.type, RDF::OWL.Ontology]
      graph << [uri, RDF::RDFS.label, 'Yet Another RussNet']
      graph << [uri, RDF::DC.title, 'Yet Another RussNet']
      graph << [uri, RDF::DC.date, Date.today.iso8601]

      i = 0

      Word.where(deleted_at: nil).find_each do |word|
        subject = RDF::URI(word_url(word.id))
        subject_form = subject + '#form'

        pos = case word.grammar
        when 'n' then RDF::LexInfo.noun
        when 'a' then RDF::LexInfo.adjective
        when 'v' then RDF::LexInfo.verb
        end

        form = RDF::Literal.new(word.word, :language => :ru)

        graph << [subject, RDF.type, RDF::Lemon.LexicalEntry]
        graph << [subject, RDF::RDFS.label, form]
        graph << [subject, RDF::Lemon.canonicalForm, subject_form]
        graph << [subject, RDF::LexInfo.partOfSpeech, pos] if pos
        graph << [subject, RDF::Lemon.entry, uri]

        graph << [subject_form, RDF.type, RDF::Lemon.Form]
        graph << [subject_form, RDF::Lemon.writtenRep, form]

        p i if (i += 1) % 1000 == 0 and !Rails.env.production?
      end

      i = 0

      Synset.select('current_synsets.id, array_agg(current_words.id) AS words_agg, array_agg(current_synset_words.id) AS synset_words_agg').
      joins(:words).joins(:words => :word).
      where(current_synset_words: { deleted_at: nil }).
      where(current_words: { deleted_at: nil}).
      where(deleted_at: nil).
      group('current_synsets.id').find_each do |synset|
        subject = RDF::URI(synset_url(synset.id))

        graph << [subject, RDF::type, RDF::SKOS.Concept]

        synset.words_agg.zip(synset.synset_words_agg) do |word_id, synset_word_id|
          subject_sense = RDF::URI(synset_word_url(synset_word_id))
          subject_word = RDF::URI(word_url(word_id))

          graph << [subject_sense, RDF.type, RDF::Lemon.LexicalSense]
          graph << [subject_sense, RDF::DC.source, uri]
          graph << [subject_sense, RDF::Lemon.reference, subject]
          graph << [subject, RDF::Lemon.isReferenceOf, subject_sense]
          graph << [subject_word, RDF::Lemon.sense, subject_sense]
          graph << [subject_sense, RDF::Lemon.isSenseOf, subject_word]
        end

        p i if (i += 1) % 500 == 0 and !Rails.env.production?
      end

      i = 0

      SynsetWord.joins(:synsets).joins(:definitions).
      where(current_synsets: { deleted_at: nil }).
      where(current_definitions: { deleted_at: nil }).
      where(deleted_at: nil).find_each do |synset_word|
        subject_sense = RDF::URI(synset_word_url(synset_word.id))

        synset_word.definitions.each do |definition|
          subject = RDF::URI(definition_url(definition.id))

          text = RDF::Literal.new(definition.text, :language => :ru)
          source = RDF::Literal.new(definition.source, :language => :ru) if definition.source

          graph << [subject, RDF.type, RDF::Lemon.SenseDefinition]
          graph << [subject, RDF::RDFS.label, text]
          graph << [subject, RDF::Lemon.value, text]
          graph << [subject, RDF::DC.source, source] if source
          graph << [subject_sense, RDF::Lemon.definition, subject]
        end

        p i if (i += 1) % 500 == 0 and !Rails.env.production?
      end

      i = 0

      SynsetWord.joins(:synsets).joins(:examples).
      where(current_synsets: { deleted_at: nil }).
      where(current_examples: { deleted_at: nil }).
      where(deleted_at: nil).find_each do |synset_word|
        subject_sense = RDF::URI(synset_word_url(synset_word.id))

        synset_word.examples.each do |example|
          subject = RDF::URI(example_url(example.id))

          text = RDF::Literal.new(example.text, :language => :ru)
          source = RDF::Literal.new(example.source, :language => :ru) if example.source

          graph << [subject, RDF.type, RDF::Lemon.UsageExample]
          graph << [subject, RDF::RDFS.label, text]
          graph << [subject, RDF::Lemon.value, text]
          graph << [subject, RDF::DC.source, source] if source
          graph << [subject_sense, RDF::Lemon.example, subject]
        end

        p i if (i += 1) % 500 == 0 and !Rails.env.production?
      end

      RDF::Writer.open(Rails.root.join('public', 'yarn.n3')) do |writer|
        writer.prefix! :rdf, RDF::to_uri
        writer.prefix! :rdfs, RDF::RDFS.to_uri
        writer.prefix! :owl, RDF::OWL.to_uri
        writer.prefix! :dc, RDF::DC::to_uri
        writer.prefix! :skos, RDF::SKOS.to_uri
        writer.prefix! :lemon, RDF::Lemon.to_uri
        writer.prefix! :lexinfo, RDF::LexInfo.to_uri

        writer << graph
      end
    end
  end
end
