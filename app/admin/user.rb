AdminController.register(User) do
  filter :email
  filter :cpf
  filter :current_sign_in_at
  filter :sign_in_count
  filter :updated_at
  filter :created_at
end
