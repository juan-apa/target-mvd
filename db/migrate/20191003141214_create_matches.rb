class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.references :target_creator
      t.references :target_compatible
      t.references :user_creator
      t.references :user_compatible

      t.timestamps
    end
    add_foreign_key :matches, :targets, column: :target_creator_id, primary_key: :id
    add_foreign_key :matches, :targets, column: :target_compatible_id, primary_key: :id
    add_foreign_key :matches, :users, column: :user_creator_id, primary_key: :id
    add_foreign_key :matches, :users, column: :user_compatible_id, primary_key: :id
  end
end
