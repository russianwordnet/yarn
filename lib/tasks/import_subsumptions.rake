namespace :yarn do
  namespace :import do
    desc 'Import raw subsumptions from a CSV file'
    task :subsumptions => :environment do
      if dry = ENV['dry'].present?
        STDERR.puts 'Working in dry mode, changes will not be made.'
      end

      csv = if ENV['csv'].present?
        CSV.open(ENV['csv'], headers: true)
      else
        raise 'Missing ENV["csv"]'
      end

      source = if ENV['source'].present?
        source = ENV['source']
      else
        raise 'Missing ENV["source"]'
      end

      ActiveRecord::Base.connection.reset_pk_sequence! RawSubsumption.table_name unless dry

      begin
        csv.each_slice(228) do |slice|
          RawSubsumption.transaction do
            entries = slice.map { |s| [s['hypernym'], s['hyponym']] }.flatten!.uniq
            words = Word.where(word: entries, deleted_at: nil).
              order('frequency DESC').group_by(&:word)

            slice.each do |row|
              next unless hypernym = words[row['hypernym']].try(:first) and
                          hyponym = words[row['hyponym']].try(:first)
              begin
                RawSubsumption.create!(hypernym: hypernym, hyponym: hyponym, source: source)
              rescue ActiveRecord::RecordNotUnique
              rescue ActiveRecord::RecordInvalid
              end
            end

            raise ActiveRecord::Rollback if dry
          end
        end
      ensure
        csv.close
      end

      ActiveRecord::Base.connection.reset_pk_sequence! RawSubsumption.table_name unless dry
    end
  end
end
