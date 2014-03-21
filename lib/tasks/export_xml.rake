namespace :yarn do
  namespace :export do
    desc 'Export the thesaurus in the XML format to /public/yarn.xml'
    task :xml => :environment do
      XSD = 'https://raw.github.com/russianwordnet/yarn-schemas/master/yarn.xsd'

      xmlid = proc do |entry|
        case entry
        when Word then 'w%d' % entry.id
        when Synset then 's%d' % entry.id
        when Definition then 'd%d' % entry.id
        when Example then 'e%d' % entry.id
        else raise 'Unknown class: %s' % entry.class
        end
      end

      version = proc do |entry|
        {
          id: xmlid[entry],
          author: entry.author_id,
          version: entry.revision,
          timestamp: entry.updated_at
        }
      end

      class Hash
        def compact
          keys.each { |k| delete(k) unless self[k] }
          self
        end
      end

      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.yarn('xmlns' => 'http://russianword.net',
                 'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                 'xsi:schemaLocation' => 'http://russianword.net ' << XSD) do
          xml.words do
            Word.where(deleted_at: nil).find_each do |word|
              xml.wordEntry(version[word]) do
                xml.word(word.word)
                xml.grammar(word.grammar) if word.grammar
                word.accents.each do |accent|
                  xml.accent(accent)
                end
                word.uris.each do |uri|
                  xml.url(uri)
                end
              end
            end
          end

          xml.synsets do
            Synset.where(deleted_at: nil).find_each do |synset|
              xml.synsetEntry(version[synset]) do
                synset.words_without_default_first.where(deleted_at: nil).each do |synset_word|
                  xml.word({ ref: xmlid[synset_word.word], nonStandardGrammar: !!synset_word.nsg }.compact) do
                    synset_word.marks.each do |mark|
                      xml.mark(mark.name)
                    end
                    synset_word.definitions.where(deleted_at: nil).each do |definition|
                      xml.definition(definition.text, { source: definition.source, url: definition.uri }.compact)
                    end
                    synset_word.examples.where(deleted_at: nil).each do |example|
                      xml.example(example.text, { source: example.source, url: example.uri }.compact)
                    end
                  end
                end
              end
            end
          end
        end
      end

      File.open(File.join(Rails.root, 'public', 'yarn.xml'), 'w') do |f|
        f.puts builder.to_xml
      end
    end
  end
end
