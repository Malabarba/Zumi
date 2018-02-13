module PermittedParams
  extend ActiveSupport::Concern

  def param_key
    self.class.model_name.param_key
  end

  def permitted_params(*args)
    self.class.permitted_params(*args)
  end

  def permitted_update!(params)
    update!(params.require(param_key)
                  .permit(permitted_params(:update)))
  end

  class_methods do
    def permitted_params(*modifiers)
      @permitted_params[modifiers.sort] ||
        (raise "Unknown modifiers: #{modifiers}")
    end

    def permitted_create!(params)
      create!(params.require(model_name.param_key)
                    .permit(permitted_params(:create)))
    end

    private

    def permit_params(&block)
      @permitted_params =
        PermittedParams::Compiler.new.compile(&block)
    end

    def make_spec(method, opts)
      opts ||= {}
      opts = { type: opts } if opts.is_a?(Symbol)
      if (ref = reflections[method.to_s])
        opts[:macro] ||= ref.macro
        opts[:type] ||= :association
      elsif (att = (try(:attachment_definitions) || {})[method])
        opts[:type] ||= :file
        opts[:styles] ||= att[:styles].map(&:first)
      end
      [method, opts]
    end
  end

  class Compiler
    MODIFIERS = %i(admin create update).freeze
    MODIFIER_OPTIONS = MODIFIERS.reduce([[]]) { |acc, m| acc + acc.map { |ms| ms + [m] } }.sort.freeze

    def compile(&block)
      MODIFIER_OPTIONS.map do |modifiers|
        @modifiers = modifiers
        @permitted = []
        instance_exec(&block)
        [@modifiers, @permitted]
      end.to_h
    end

    def permit(x)
      @permitted += x
    end

    MODIFIERS.each do |m|
      define_method(:"#{m}?") { @modifiers.include?(m) }
    end
  end
end
