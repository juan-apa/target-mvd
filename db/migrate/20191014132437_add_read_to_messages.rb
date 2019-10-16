class AddReadToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :read, :boolean, null: false, default: false
  end
end
