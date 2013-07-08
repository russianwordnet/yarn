# encoding: utf-8

# Serialize a Ruby array into the PostgreSQL array. The implementation is
# dirty and was copied from the postgres_ext gem.
#
def array_to_string(value, encode_single_quotes = false)
  "{#{value.map { |x| item_to_string(x, encode_single_quotes) }.join(',')}}"
end

# Serialize a Ruby value into the PostgreSQL value. This method was copied
# from the postgres_ext gem.
#
def item_to_string(value, encode_single_quotes = false)
  return 'NULL' if value.nil?

  if value.is_a?(String)
    value = value.dup
    # Encode backslashes.  One backslash becomes 4 in the resulting SQL.
    # (why 4, and not 2?  Trial and error shows 4 works, 2 fails to parse.)
    value.gsub!('\\', '\\\\\\\\')
    # Encode a bare " in the string as \"
    value.gsub!('"', '\\"')
    # PostgreSQL parses the string values differently if they are quoted for
    # use in a statement, or if it will be used as part of a bound argument.
    # For directly-inserted values (UPDATE foo SET bar='{"array"}') we need to
    # escape ' as ''.  For bound arguments, do not escape them.
    if encode_single_quotes
      value.gsub!("'", "''")
    end

    "\"#{value}\""
  else
    value
  end
end

# Load the duplicated words list and represent it as a Hash.
#
def load_duplicated_words(filename)
  Hash.new.tap do |duplicated_words|
    CSV.foreach(filename) do |row|
      duplicated_words[row[0]] = row[1].to_i
    end
  end
end

# Process words and write them to the CSV file.
#
def write_words(xml, csv, duplicated_words, offset)
  xml.xpath('//wordEntry').each do |entry|
    id, author, timestamp = entry[:id], entry[:author],
      entry[:timestamp]

    next if duplicated_words[id]
    next unless word = entry.xpath('./word[1]').map(&:text).first

    grammar = entry.xpath('./grammar[1]').map(&:text).first
    accents = entry.xpath('./accent').map(&:text).map(&:to_i)
    uris = entry.xpath('./url').map(&:text)

    csv << { 'id' => item_to_string(offset + id[/\d+/].to_i),
             'author_id' => item_to_string(ENV['author_id'].to_i),
             'word' => item_to_string(word),
             'grammar' => item_to_string(grammar),
             'accents' => array_to_string(accents),
             'uris' => array_to_string(uris) }
  end
end

# Process synsets, definitions, synset_words and samples, and write
# them to the CSV files.
#
def write_synsets(xml, csv_s, csv_d, csv_sw, csv_sa, duplicated_words,
                  words_offset, synsets_offset, definitions_offset,
                  synset_words_offset, samples_offset)
  synset_id = synsets_offset
  definition_id = definitions_offset
  synset_word_id = synset_words_offset
  sample_id = samples_offset

  xml.xpath('//synsetEntry').each do |entry|
    definitions = entry.xpath('./definition').map do |definition|
      csv_d << { 'id' => item_to_string(definition_id += 1),
                 'author_id' => item_to_string(ENV['author_id'].to_i),
                 'text' => item_to_string(definition.text),
                 'source' => item_to_string(definition[:source]),
                 'uri' => item_to_string(definition[:uri]) }
      definition_id
    end

    synset_words = entry.xpath('./word').map do |word|
      ref = if word[:ref]
        duplicated_words[word[:ref]] || (words_offset + word[:ref][/\d+/].to_i)
      end

      nsg = word[:nonStandardGrammar] == 'true'
      marks = word.xpath('./mark').map(&:text)

      samples = word.xpath('./sample').map do |sample|
        csv_sa << { 'id' => item_to_string(sample_id += 1),
                    'author_id' => item_to_string(ENV['author_id'].to_i),
                    'text' => item_to_string(sample.text),
                    'source' => item_to_string(sample[:source]),
                    'uri' => item_to_string(sample[:uri]) }
        sample_id
      end

      csv_sw << { 'id' => item_to_string(synset_word_id += 1),
                  'author_id' => item_to_string(ENV['author_id'].to_i),
                  'word_id' => item_to_string(ref),
                  'nsg' => item_to_string(nsg),
                  'marks' => array_to_string(marks),
                  'samples_ids' => array_to_string(samples) }
      synset_word_id
    end

    csv_s << { 'id' => item_to_string(synset_id += 1),
               'author_id' => item_to_string(ENV['author_id'].to_i),
               'definitions_ids' => array_to_string(definitions),
               'words_ids' => array_to_string(synset_words) }
  end
end

namespace :yarn do
  desc 'Import a dictionary in the YARN format'
  task :import => :environment do
    raise 'Missing ENV["xml"]' unless ENV['xml']
    raise 'Missing ENV["path"]' unless ENV['path']
    raise 'Missing ENV["author_id"]' unless ENV['author_id']

    duplicated_words = if ENV['duplicates']
      load_duplicated_words(ENV['duplicates'])
    else
      {}
    end

    FileUtils.mkdir_p ENV['path']

    xml = Nokogiri::XML(File.open(ENV['xml']))

    puts 'Hey, there are %d words and %d synsets in "%s".' % [
      xml.xpath('//wordEntry').size,
      xml.xpath('//synsetEntry').size,
      ENV['xml']
    ]

    words_offset = Word.maximum(:id) || 0
    synsets_offset = RawSynset.maximum(:id) || 0
    definitions_offset = Definition.maximum(:id) || 0
    synset_words_offset = RawSynsetWord.maximum(:id) || 0
    samples_offset = RawSample.maximum(:id) || 0

    words_path = File.expand_path('current_words.csv', ENV['path'])
    CSV.open(words_path, 'w', write_headers: true, headers: Word.column_names) do |csv|
      write_words(xml, csv, duplicated_words, words_offset)
    end
    puts 'Words were written to "%s"' % words_path

    synsets_path = File.expand_path('raw_synsets.csv', ENV['path'])
    definitions_path = File.expand_path('current_definitions.csv', ENV['path'])
    synset_words_path = File.expand_path('raw_synset_words.csv', ENV['path'])
    samples_path = File.expand_path('raw_samples.csv', ENV['path'])

    CSV.open(synsets_path, 'w', write_headers: true, headers: RawSynset.column_names) do |csv_s|
      CSV.open(definitions_path, 'w', write_headers: true, headers: Definition.column_names) do |csv_d|
        CSV.open(synset_words_path, 'w', write_headers: true, headers: RawSynsetWord.column_names) do |csv_sw|
          CSV.open(samples_path, 'w', write_headers: true, headers: RawSample.column_names) do |csv_sa|
            write_synsets(xml, csv_s, csv_d, csv_sw, csv_sa, duplicated_words,
              words_offset, synsets_offset, definitions_offset,
              synset_words_offset, samples_offset)
          end
        end
      end
    end

    puts 'Synsets were written to "%s"' % synsets_path
    puts 'Definitions were written to "%s"' % definitions_path
    puts 'SynsetWords were written to "%s"' % synset_words_path
    puts 'Samples were written to "%s"' % samples_path
  end
end
