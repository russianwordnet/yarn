namespace :yarn do
  namespace :subsumptions do
    desc 'Emit subsumption assigments based on the raw data'
    task :assigments => :environment do
      SubsumptionAssignment.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence! SubsumptionAssignment.table_name

      i = 0
      RawSubsumption.find_each do |raw|
        hypernym_synsets = Synset.joins(:lexemes).where(current_words: { id: raw.hypernym }, deleted_at: nil)
        hypernym_synsets.keep_if { |s| s.default_word == raw.hypernym }

        hyponym_synsets = Synset.joins(:lexemes).where(current_words: { id: raw.hyponym }, deleted_at: nil)
        hyponym_synsets.keep_if { |s| s.default_word == raw.hyponym }

        if hypernym_synsets.any? && hyponym_synsets.any?
          p([i += 1, raw.id])
        end

        SubsumptionAssignment.transaction do
          hypernym_synsets.each do |hypernym_synset|
            hyponym_synsets.each do |hyponym_synset|
              begin
                SubsumptionAssignment.create!(
                  hypernym_synset: hypernym_synset,
                  hyponym_synset: hyponym_synset,
                  raw_subsumption: raw
                )
              rescue ActiveRecord::RecordNotUnique
              rescue ActiveRecord::RecordInvalid
              end
            end
          end
        end
      end
    end
  end
end
