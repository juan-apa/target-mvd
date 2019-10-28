class AddTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.string :title, { null: false, limit: 40, unique: true }

      t.timestamps
    end

    add_index :topics, :title, unique: true
  end
end
