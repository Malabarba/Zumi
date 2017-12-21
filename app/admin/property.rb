ActiveAdmin.register Property do
  extend AdminController

  update_form(Property.permitted_params)

  index do
    id_column
    Property::INDEX_COLUMNS[:admin].each do |c|
      column(c)
    end
  end
end
