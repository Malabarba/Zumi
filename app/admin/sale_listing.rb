AdminController.register(SaleListing) do
  resource_action(:publish, title: 'Publicar')
  resource_action(:remove, title: 'Remover')
  resource_action(:schedule_visit, title: 'Agendar Visita')
end  
