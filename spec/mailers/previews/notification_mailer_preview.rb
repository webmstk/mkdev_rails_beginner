# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/pending_cards
  def pending_cards
    NotificationMailer.pending_cards(User.first)
  end

end
