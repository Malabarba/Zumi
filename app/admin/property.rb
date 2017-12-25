AdminController.register(Property) do
  action_item :list_sale, only: [:show] do
    link_to 'Listar Venda', new_admin_sale_listing_path(sale_listing: { property_id: resource.id })
  end
end
