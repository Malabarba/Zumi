module Serializable
  extend ActiveSupport::Concern

  def as_json(opts = {})
    out = {}
    self.class.serialization.each do |m, type:, macro: |
      if type == :association
        if association_cached?(m) || !opts[:shallow]
          if macro == :has_many
            out[m] = send(m)&.as_json(opts.merge(shallow: true))
          else
            out[m] = send(m)&.as_json(opts)
          end
        end
      else
        out[m] = send(m)&.as_json(opts)
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
      @serialization = (@serialize_with || []).map(&method(:make_spec)).to_h
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
      opts[:macro] ||= reflections[method.to_s]&.macro
      opts[:type] ||= if reflections[method.to_s]
                        :association
                      end
      [method, opts]
    end
  end
end
