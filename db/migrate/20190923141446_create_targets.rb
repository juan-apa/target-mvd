class CreateTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :targets do |t|
      t.string :title,      { null: false, limit: 40 }
      t.integer :radius,    { null: false, limit: 2 }
      t.decimal :latitude,  { null: false, precision: 10, scale: 6 }
      t.decimal :longitude, { null: false, precision: 10, scale: 6 }

      t.belongs_to :user
      t.belongs_to :topic

      t.timestamps
    end
    add_index :targets, [:latitude, :longitude]
  end
end
