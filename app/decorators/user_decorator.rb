class UserDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all

  def avatar_link
    if avatar.attached?
      link_to('avatar', polymorphic_url(avatar))
    else
      I18n.t('admin.messages.no_avatar_attached')
    end
  end
end
