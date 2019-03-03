# frozen_string_literal: true

module Actionable
  extend ActiveSupport::Concern

  def may?(action, **context)
    instance_exec(context, &self.class.actions[action][:ability])
  end

  class_methods do
    def is_owner
      proc { |user:| user == owner }
    end

    def actions
      @actions || {}
    end

    def defaction(action, label,
                  user_ability: nil, params: [],
                  **opts, &block)
      opts[:unless] ||= {}
      opts[:if] ||= {}

      may = proc do |context = {}|
        next false if (user_ability == :admin || !evals_true?(user_ability, context)) &&
                      !context[:user]&.admin?
        next true unless (e = (opts[:unless].find { |cond, _| !evals_true?(cond, context) } ||
                               opts[:if].find { |cond, _| evals_true?(cond, context) }))

        errors.add(:base, e[1]) if context[:with_errors]
        false
      end

      @actions ||= {}
      @actions[action] = { permitted_params: params, ability: may, action: action, label: label }.freeze

      define_method("#{action}!") do |args: {}, **opts|
        next false unless may?(action, opts.merge(with_errors: true))

        instance_exec(*args, &block)
      end
    end
  end

  private

  def evals_true?(ability, *args)
    case ability
    when nil then true
    when Symbol then instance_eval(&ability)
    else instance_exec(*args, &ability)
    end
  end
end
