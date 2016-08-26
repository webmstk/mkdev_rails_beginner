require 'rails_helper'

feature 'delay review_date' do
  let(:user) { create :user }
  let!(:card) { create :expired_card, user: user }

  scenario 'user answers coorectly and then makes mistake 3 times in a row' do
    login user


    # Проверяем, что время откладывается по нарастающей

    Card::REVIEW_DELAY_DAYS.each do |success, delay|
      visit random_cards_path
      fill_in t('helpers.labels.card.translated_text'), with: card.translated_text
      click_on t(:check_translation)

      Timecop.freeze(delay.days.from_now - 1.hour)
      visit random_cards_path
      expect(page).to have_text t('cards.random.relax')

      Timecop.freeze(delay.days.from_now)
      visit random_cards_path
      expect(page).not_to have_text t('cards.random.relax')
    end


    # ошибаемся больше, чем позволено

    visit random_cards_path
    (Card::GUESS_ATTEMPTS + 1).times do |i|
      fill_in t('helpers.labels.card.translated_text'), with: 'asdfsd'
      click_on t(:check_translation)
    end


    # отвечаем правильно

    fill_in t('helpers.labels.card.translated_text'), with: card.translated_text
    click_on t(:check_translation)


    # И проверяем, что карточка отложена на минимальный срок

    Timecop.freeze(Card::REVIEW_DELAY_DAYS.values.first.days.from_now - 1.hour)
    visit random_cards_path
    expect(page).to have_text t('cards.random.relax')

    Timecop.freeze(Card::REVIEW_DELAY_DAYS.values.first.days.from_now)
    visit random_cards_path
    expect(page).not_to have_text t('cards.random.relax')
  end
end
