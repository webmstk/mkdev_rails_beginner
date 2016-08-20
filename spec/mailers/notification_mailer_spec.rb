require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  describe 'pending_cards' do
    let(:user) { create :user }
    let(:cards) { create_list :expired_card, 2, user: user }
    let(:mail) { NotificationMailer.pending_cards(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Появились карточки к пересмотру')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@pacific-taiga-56343.herokuapp.com'])
    end

    it 'renders the body' do
      cards
      # expect(mail.body.encoded).to match(Base64.strict_encode64 'Пора учиться!')

      expect(mail.html_part.body.raw_source).to match('Пора учиться!')
      expect(mail.html_part.body.raw_source).to match('Карточек к пересмотру: 2')
      
      expect(mail.text_part.body.raw_source).to match('Пора учиться!')
      expect(mail.text_part.body.raw_source).to match('Карточек к пересмотру: 2')
    end
  end

end
