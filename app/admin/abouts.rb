ActiveAdmin.register About do
  permit_params :content

  scope :all, default: true

  index do
    column(:content)
    actions
  end

  filter :about

  form do |f|
    f.inputs do
      f.input :content
    end
    f.actions
  end
end
