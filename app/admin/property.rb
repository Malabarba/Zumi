AdminController.register(Property) do
  action_item :list, only: [:show] do
    link_to 'Listar Venda', new_admin_listing_path(listing: { property_id: resource.id })
  end
end
