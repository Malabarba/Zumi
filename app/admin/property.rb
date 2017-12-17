ActiveAdmin.register Property do
  permit_params(*Property.permitted_params)

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      AdminForm.make_inputs(f, Property.permitted_params)
    end
    f.actions
  end
end
