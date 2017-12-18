require_dependency 'admin_controller.rb'

ActiveAdmin.register SaleListing do
  extend AdminController

  update_form(SaleListing.permitted_params)

  index do
    id_column
    SaleListing::INDEX_COLUMNS[:admin].each do |c|
      column(c)
    end
  end

  resource_action(:publish, title: 'Publicar')
end
