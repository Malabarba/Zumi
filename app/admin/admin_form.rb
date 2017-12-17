module AdminForm
  def self.make_inputs(f, params)
    params.each do |p|
      case p
      when Symbol
        f.input(p.to_s.gsub(/_id$/, ''))
      when Hash
        p.each do |k, subparams|
          col = k.to_s.gsub(/_attributes$/, '').to_sym
          f.object.public_send("build_#{col}") unless f.object.public_send(col)
          f.inputs(f.object.class.human_attribute_name(col), for: col) do |ff|
            AdminForm.make_inputs(ff, subparams - [:id])
          end
        end
      else raise "Found #{p.class} in params: #{p.inspect}"
      end
    end
  end
end
