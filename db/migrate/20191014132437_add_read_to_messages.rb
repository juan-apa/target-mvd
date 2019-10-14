class AddReadToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :read, :boolean, null: false
    Message.all.each { |message| message.update!(read: false) }
  end
end
