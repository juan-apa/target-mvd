class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.references :target_1
      t.references :target_2
    end
    add_foreign_key :matches, :targets, column: :target_1_id, primary_key: :id
    add_foreign_key :matches, :targets, column: :target_2_id, primary_key: :id
  end
end
