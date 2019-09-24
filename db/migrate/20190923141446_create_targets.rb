class CreateTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :targets do |t|
      t.string :title
      t.integer :radius
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.belongs_to :user
      t.belongs_to :topic

      t.timestamps
    end
    add_index :targets, [:latitude, :longitude]
  end
end
