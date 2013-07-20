# encoding: utf-8

# A mixin that allows to simplify history tracking of model changes.
#
module YarnHistory
  extend ActiveSupport::Concern

  module ClassMethods
    def has_history(association, attributes, options = {})
      self.has_many association, options
      attr_reader :yarn_has_history
      @yarn_has_history = attributes
    end

    def history_of(association, attributes, options = {})
      belongs_to association, options
      attr_reader :yarn_history_of
      @yarn_history_of = attributes
    end
  end

  def update_history(new_model)
    self.class.transaction do
      origin = self.history_class.save_history(self)

      yarn_has_history.each do |attr|
        setter = ('%s=' % attr).to_sym
        self.send(setter, new_model.send(attr))
      end

      self.revision += 1

      return self.save.tap { |saved| origin.save! if saved }
    end
  end

  def save_history(origin)
    self.history_association.build do |model|
      yarn_history_of.each do |attr|
        setter = ('%s=' % attr).to_sym
        model.send(setter, origin.send(attr))
      end

      model.revision = origin.revision
      model.created_at = origin.updated_at
    end
  end
end

ActiveRecord::Base.send(:extend, YarnHistory)
