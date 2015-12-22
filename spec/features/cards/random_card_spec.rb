require 'rails_helper'

feature 'get learn with random cards' do
  describe 'there are no cards to translate' do
    scenario 'user sees message that all cards have been translated' do
      visit random_cards_path
      expect(page).to have_text 'Отдыхай, ты проработал все карточки на сегодня.'
    end
  end


  describe 'there are cards to translate' do
    given!(:card) { create :card }
    given!(:expired_card) { create :expired_card }

    scenario 'user sees random card with expired review date' do
      visit random_cards_path
      expect(page).to have_text expired_card.original_text
    end

    scenario 'user cannot see cards with not expired review date' do
      visit random_cards_path
      expect(page).to_not have_text card.original_text
    end


    describe 'user translates card' do
      context 'correctly' do
        scenario 'and gets a new card' do
          visit random_cards_path
          fill_in 'Перевод', with: expired_card.translated_text
          click_on 'Проверить перевод'

          expect(current_path).to eq random_cards_path
          expect(page).to have_text 'Правильно'
          expect(page).to_not have_text expired_card.original_text
        end
      end

      context 'incorrectly' do
        scenario 'and gets error message if translation is not provided' do
          visit random_cards_path
          fill_in 'Перевод', with: ''
          click_on 'Проверить перевод'

          expect(current_path).to eq card_check_path(expired_card)
          expect(page).to have_text 'Поле не может быть пустым'
          expect(page).to have_text expired_card.original_text
        end

        scenario 'and gets message with correct translation' do
          visit random_cards_path
          fill_in 'Перевод', with: 'Wrong translation'
          click_on 'Проверить перевод'

          expect(current_path).to eq card_check_path(expired_card)
          expect(page).to have_text "Правильно: #{expired_card.translated_text}"
          expect(page).to have_text expired_card.original_text
        end
      end
    end
  end
end