class CreateConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations do |t|

    end

    change_table :matches do |t|
      t.belongs_to :conversation
    end
  end
end
