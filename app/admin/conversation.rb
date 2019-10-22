ActiveAdmin.register Conversation do
  scope :all, default: true

  show do
    panel 'Messages' do
      table_for(conversation.messages) do |t|
        t.column(:user)
        t.column(:body)
        t.column(:created_at)
      end
    end
  end
end
