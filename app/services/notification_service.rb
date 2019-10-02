module NotificationService
  extend self

  def create_notification(notification_token, notification)
    puts 'notification created for notification_token: ' + notification_token + ' notification: ' +
    notification.to_s

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
end
