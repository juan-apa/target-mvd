class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.belongs_to :user
      t.belongs_to :conversation
      t.text :body, { null: false }

      t.timestamps
    end
  end
end
