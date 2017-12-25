AdminController.register(SaleListing) do
  resource_action(:publish, title: 'Publicar')
  resource_action(:remove, title: 'Remover')

  action_item :schedule_visit, only: [:show] do
    link_to 'Agendar Visita', new_admin_visit_path(visit: { sale_listing_id: resource.id })
  end
end  
