ActiveAdmin.register User do
  decorate_with UserDecorator

  menu priority: 2
  actions :index, :show

  scope :all, default: true

  index do
    column('User', sortable: :id) { |user| link_to "##{user.id} ", admin_user_path(user) }
    column('Email', :email)
    column('First Name', :first_name)
    column('Last Name', :last_name)
    column('Gender', :gender)
    column('Avatar', &:avatar_link)
    column('Created At', :created_at)
    column('Updated At', :updated_at)
    column('Confirmed At', :confirmed_at)
    column('Notification Token', :notification_token)
  end

  show do
    panel 'Targets' do
      table_for(user.targets) do |t|
        t.column('Title') { |target| link_to target.title, admin_target_path(target) }
      end
    end
  end
end
