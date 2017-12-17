require_dependency 'admin_controller.rb'

ActiveAdmin.register SaleListing do
  extend AdminController

  permit_params(*SaleListing.permitted_params)

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      AdminForm.make_inputs(f, SaleListing.permitted_params)
    end
    f.actions
  end

  index do
    id_column
    SaleListing::INDEX_COLUMNS[:admin].each do |c|
      column(c)
    end
  end

  resource_action(:publish, title: 'Publicar', args: [:published_at])
end
