class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.pending_cards.subject
  #
  def pending_cards(user)
    @cards = user.cards

    mail to: user.email, subject: 'Появились карточки к пересмотру'
  end
end
