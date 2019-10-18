ActiveAdmin.register Target do
  menu priority: 3
  actions :index, :show

  scope :all, default: true

  index do
    column('Target', sortable: :id) { |target| link_to "##{target.id} ", admin_target_path(target) }
    column('Title', :title)
    column('User', :user)
    # {|target| link_to "##{target.user.id} ", admin_user_path(target.user) }
    column('Topic', :topic)
    # {|target| link_to "##{target.topic.title} ", admin_topic_path(target.topic) }
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
        t.column('Conversation') { |match| "##{match.conversation.id}" }
      end
    end
  end
end
