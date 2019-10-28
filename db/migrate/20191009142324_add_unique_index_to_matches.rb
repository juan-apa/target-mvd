class AddUniqueIndexToMatches < ActiveRecord::Migration[6.0]
  def change
    add_index :matches, [:target_creator_id, :target_compatible_id], unique: true
  end
end
