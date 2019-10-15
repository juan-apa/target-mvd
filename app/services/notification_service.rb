module NotificationService
  extend self

  def create_notification(device_tokens)
    notification = {
      title: I18n.t('messages.notification.target.new.title'),
      body: I18n.t('messages.notification.target.new.body')
    }
    device_tokens.each do |device_token|
      msg = `notification created for notification_token: #{device_token}
            notification: #{notification}`
      Rails.logger.info(msg)
    end

    # The notification sending code is commented out because now, there is no app
    # that generates device-tokens. Now it only prints the dummy notification token.

    # n = Rpush::Gcm::Notification.new
    # n.app = Rpush::Gcm::App.find_by(name: ENV.fetch('NOTIFICATION_APP_NAME'))
    # n.registration_ids = [notification_token]
    # n.data = { message: notification.body }
    # n.notification = {
    #     body: notification.body,
    #     title: notification.title
    # }
    # n.save!
  end

  def new_message_notification(device_token)
    notification = {
      title: I18n.t('messages.notification.message.new.title'),
      body: I18n.t('messages.notification.message.new.body')
    }
    msg = 'notification created for notification_token: ' + device_token + 'notification: ' +
          notification.to_s
    Rails.logger.info(msg)
  end
end
