require 'rails_helper'

feature 'delay review_date' do
  let(:user) { create :user }
  let!(:card) { create :expired_card, user: user }

  scenario 'user answers coorectly and then makes mistake 3 times in a row' do
    login user


    # Проверяем, что время откладывается по нарастающей

    Card::REVIEW_DELAY_DAYS.each do |success, delay|
      visit random_cards_path
      fill_in 'Перевод', with: card.translated_text
      click_on 'Проверить перевод'

      Timecop.freeze(delay.days.from_now - 1.hour)
      visit random_cards_path
      expect(page).to have_text 'Отдыхай, ты проработал все карточки на сегодня.'

      Timecop.freeze(delay.days.from_now)
      visit random_cards_path
      expect(page).not_to have_text 'Отдыхай, ты проработал все карточки на сегодня.'
    end


    # ошибаемся больше, чем позволено

    visit random_cards_path
    (Card::GUESS_ATTEMPTS + 1).times do |i|
      fill_in 'Перевод', with: 'asdfsd'
      click_on 'Проверить перевод'
    end


    # отвечаем правильно

    fill_in 'Перевод', with: card.translated_text
    click_on 'Проверить перевод'


    # И проверяем, что карточка отложена на минимальный срок

    Timecop.freeze(Card::REVIEW_DELAY_DAYS.values.first.days.from_now - 1.hour)
    visit random_cards_path
    expect(page).to have_text 'Отдыхай, ты проработал все карточки на сегодня.'

    Timecop.freeze(Card::REVIEW_DELAY_DAYS.values.first.days.from_now)
    visit random_cards_path
    expect(page).not_to have_text 'Отдыхай, ты проработал все карточки на сегодня.'
  end
end
