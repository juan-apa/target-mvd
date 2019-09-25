class CreateTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :targets do |t|
      t.string :title,      { presence: true, null: false, limit: 40 }
      t.integer :radius,    { presence: true, null: false, limit: 2 }
      t.decimal :latitude,  { precision: 10, scale: 6, presence: true, null: false }
      t.decimal :longitude, { precision: 10, scale: 6, presence: true, null: false }

      t.belongs_to :user
      t.belongs_to :topic

      t.timestamps
    end
    add_index :targets, [:latitude, :longitude]
  end
end
