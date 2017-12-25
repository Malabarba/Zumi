class RenameUserIdToOwnerIdInProperties < ActiveRecord::Migration[5.1]
  def change
    rename_column :properties, :user_id, :owner_id
  end
end
