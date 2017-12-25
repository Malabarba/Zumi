class ChangeVisitorNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null(:visits, :visitor_id, true)
  end
end
