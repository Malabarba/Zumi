module Serializable
  extend ActiveSupport::Concern

  ONE_WEEK = 7 * 24 * 60 * 60

  def as_json(opts = {})
    out = {}
    self.class.serialization.each do |method, **spec|
      if spec[:type] == :association
        if association_cached?(method) || !opts[:shallow]
          if spec[:macro] == :has_many
            out[method] = send(method)&.as_json(opts.merge(shallow: true))
          else
            out[method] = send(method)&.as_json(opts)
          end
        end
      elsif spec[:type] == :file
        file = send(method)
        out[method] = spec[:styles].reduce(url: file.expiring_url(ONE_WEEK)) do |h, s|
          h.merge(s => file.expiring_url(ONE_WEEK, s))
        end
      else
        out[method] = send(method)&.as_json(opts)
      end
    end
    out
  end

  class_methods do
    def serialize_with(*methods, **methods_hash)
      methods.each { |m| methods_hash[m] = nil }
      @serialize_with = methods_hash
    end

    def serialization
      return @serialization if @serialization
      @serialization = (@serialize_with || []).map { |k, v| make_spec(k, v) }.to_h
    end

    def admin_index_columns(&block)
      @index_columns_block = block
    end

    def index_columns(*args)
      @index_columns_block&.call(*args)
    end

    private

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
end
