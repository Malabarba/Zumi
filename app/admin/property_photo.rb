AdminController.register(PropertyPhoto, destroy_action: true) do
  scope('Ativas', :all, default: true)
  scope('Deletadas', :deleted)
end
