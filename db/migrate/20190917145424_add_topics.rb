class AddTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.string :title, { presence: true, null: false, limit: 40, unique: true }

      t.timestamps
    end
  end
end
