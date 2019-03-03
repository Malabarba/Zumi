# frozen_string_literal: true

AdminController.register(Listing) do
  action_item :schedule_visit, only: [:show] do
    link_to 'Agendar Visita', new_admin_visit_path(visit: { listing_id: resource.id })
  end
end
