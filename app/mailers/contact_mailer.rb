class ContactMailer < ApplicationMailer
  def send_question(from:, subject:, body:)
    mail(to: AdminUser.first.email, subject: subject, body: body, from: from)
  end
end
