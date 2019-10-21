ActiveAdmin.register Target do
  menu priority: 3
  actions :index, :show

  scope :all, default: true

  filter :topic

  index do
    column('Target', sortable: :id) { |target| link_to "##{target.id} ", admin_target_path(target) }
    column('Title', :title)
    column('User', :user)
    column('Topic', :topic)
    column('Location') { |target| "#{target.latitude},#{target.longitude}" }
    column('Date', :created_at)
  end

  show do
    panel 'Target Matches' do
      table_for(target.matches_creators + target.matches_compatible) do |t|
        t.column('Match', sortable: :id) { |match| match }
        t.column('Target Compatible', :target_compatible) do |match|
          link_to "##{match.target_compatible.id}", admin_target_path(match.target_compatible)
        end
        t.column('Target Creator', :target_creator) do |match|
          link_to "##{match.target_creator.id}", admin_target_path(match.target_creator)
        end
        t.column('Conversation') { |match| link_to "##{match.conversation.id}", admin_conversation_path(match.conversation.id) }
      end
    end
  end
end
