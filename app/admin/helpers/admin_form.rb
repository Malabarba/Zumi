module AdminForm
  def self.make_inputs(f, spec, query_params)
    spec.each do |p|
      case p
      when Symbol
        v = { input_html: { value: query_params[p] } } if query_params.include?(p)
        f.input(p.to_s.gsub(/_id$/, ''), v || {})
        if p == :file && (file = f.object.public_send(p))
          f.img(src: file.url, style: 'max-width: 500px') if file.content_type =~ /image/
        end
      when Hash
        p.each do |k, subspec|
          col = k.to_s.gsub(/_attributes$/, '').to_sym
          f.object.public_send("build_#{col}") unless f.object.public_send(col)
          f.inputs(f.object.class.human_attribute_name(col), for: col) do |ff|
            AdminForm.make_inputs(ff, subspec - [:id], query_params.fetch(k, {}))
          end
        end
      else raise "Found #{p.class} in spec: #{p.inspect}"
      end
    end
  end
end
