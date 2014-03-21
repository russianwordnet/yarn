# encoding: utf-8

# A mixin that allows to simplify history tracking of model changes.
#
module Yarn::Trackable
  module Head
    extend ActiveSupport::Concern

    included do
      has_many history_association, -> { order 'revision' }, :inverse_of => :origin
    end

    module ClassMethods
      def history_class
        self.name.prepend('Old').constantize
      end

      def history_association
        self.name.underscore.pluralize.prepend('old_').to_sym
      end
    end

    def update_with_tracking(attrs = {}, save_method = :save)
      self.class.transaction do
        old_version = self.class.history_class.from_origin(self) if need_track?

        self.author = attrs.delete(:author) if attrs[:author].present?
        self.attributes = attrs if attrs.present?
        yield self if block_given?

        return self unless self.changed?
        old_version.save! if old_version.present?

        self.revision += 1

        method(save_method).call.tap { |result| self.reload if result }
      end
    end

    def need_track?
      return false if new_record?

      send(self.class.history_association).last.blank? ||
      send(self.class.history_association).last.created_at < 12.hours.ago ||
      send(self.class.history_association).last.author_id != author_id
    end
  end

  module Tail
    extend ActiveSupport::Concern

    included do
      association_class = origin_class.to_s
      foreign_key = origin_class.to_s.foreign_key
      inverse_of = self.name.underscore.pluralize.to_sym

      belongs_to :origin,
        class_name: association_class,
        foreign_key: foreign_key,
        inverse_of: inverse_of
    end

    module ClassMethods
      def inverse_association
        self.name.underscore.pluralize.to_sym
      end

      def origin_class
        self.name.from(3).constantize
      end

      def from_origin(origin_entity)
        attrs = origin_entity.attributes.reject {|k,_| %w(id updated_at).include? k }
        attrs.merge!(created_at: origin_entity.updated_at)

        history_entity = origin_entity.send(self.inverse_association).build(attrs, without_protection: true)

        history_entity
      end
    end
  end
end
