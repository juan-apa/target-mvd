class UserFieldsNotNullable < ActiveRecord::Migration[6.0]
  def change
    # Rename columns from cammelCase to snake_case
    rename_column :users, :firstName, :first_name
    rename_column :users, :lastName, :last_name

    # Make columns not nullable
    change_column :users, :email, :string, null: false
    change_column :users, :first_name, :string, null: false
    change_column :users, :last_name, :string, null: false
    change_column :users, :gender, :string, null: false
  end
end
