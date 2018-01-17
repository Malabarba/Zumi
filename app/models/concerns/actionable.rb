module Actionable
  extend ActiveSupport::Concern

  def may?(action, **context)
    instance_exec(context, &self.class.actions[action][:ability])
  end

  class_methods do
    def actions
      @actions || {}
    end

    def defaction(action, label,
                  errors: {}, ability: nil, user_ability: nil,
                  params: [], admin: false, &block)
      may = proc do |context = {}|
        next false unless able?(ability, context)
        unless context[:user]&.admin?
          next false if admin || !able?(user_ability, context)
        end

        errors.each do |cond, error|
          next unless able?(cond, context)
          self.errors.add(:base, error)
          break
        end
        self.errors.blank?
      end

      @actions ||= {}
      @actions[action] = { params: params, ability: may, action: action, label: label }.freeze

      define_method("#{action}!") do |args:, **opts|
        next false unless may?(action, opts)
        instance_exec(*args, &block)
      end
    end
  end

  private

  def able?(ability, *args)
    case ability
    when nil then true
    when Symbol then instance_eval(&ability)
    else instance_exec(*args, &ability)
    end
  end
end
