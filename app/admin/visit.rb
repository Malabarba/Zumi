# frozen_string_literal: true

AdminController.register(Visit) do
  config.sort_order = 'at_asc'

  scope('A confirmar', :pending)
  scope('Confirmadas futuras', :to_go)
  scope('Todas', :all)

  filter :status, Visit.status_filter_opts
end
