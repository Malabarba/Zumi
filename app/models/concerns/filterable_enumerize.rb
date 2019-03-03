# frozen_string_literal: true

module FilterableEnumerize
  extend ActiveSupport::Concern

  included do
    extend Enumerize

    def self.enumerize(column, **_)
      define_singleton_method :"#{column}_filter_opts" do
        klass = self
        { as: :check_boxes,
          label: -> { klass.human_attribute_name(column) },
          collection: -> { klass.send(column).values.map { |value| [value.text, value] } } }
      end
      super
      hash = { activerecord: { attributes: { model_name.param_key => { "#{column}_text" => human_attribute_name(column) } } } }
      I18n.backend.store_translations(:'pt-BR', hash)
    end
  end
end
