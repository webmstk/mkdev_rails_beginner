require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  describe 'pending_cards' do
    let(:user) { create :user }
    let(:cards) { create_list :expired_card, 2, user: user }
    let(:mail) { NotificationMailer.pending_cards(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq t 'notification_mailer.pending_cards.subject'
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@pacific-taiga-56343.herokuapp.com'])
    end

    it 'renders the body' do
      cards
      # expect(mail.body.encoded).to match(Base64.strict_encode64 'Пора учиться!')

      expect(mail.html_part.body.raw_source).to match t('notification_mailer.pending_cards.head')
      expect(mail.html_part.body.raw_source).to match("#{t 'notification_mailer.pending_cards.cards_to_review'}: 2")
      
      expect(mail.text_part.body.raw_source).to match t('notification_mailer.pending_cards.head')
      expect(mail.text_part.body.raw_source).to match("#{t 'notification_mailer.pending_cards.cards_to_review'}: 2")
    end
  end

end
