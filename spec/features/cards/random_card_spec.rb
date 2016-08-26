require 'rails_helper'

feature 'get learn with random cards' do
  given(:user) { create :user }
  
  describe 'there are no cards to translate' do
    scenario 'user sees message that all cards have been translated' do
      login user
      visit random_cards_path
      expect(page).to have_text t('cards.random.relax')
    end
  end


  describe 'there are cards to translate' do
    let!(:card) { create :card, user: user }
    let!(:expired_card) { create :expired_card, user: user }

    scenario 'user sees random card with expired review date' do
      login user
      visit random_cards_path
      expect(page).to have_text expired_card.original_text
    end

    scenario 'user cannot see cards with not expired review date' do
      login user
      visit random_cards_path
      expect(page).to_not have_text card.original_text
    end


    describe 'user translates card' do
      context 'correctly' do
        scenario 'and gets a new card' do
          login user
          visit random_cards_path
          fill_in t('helpers.labels.card.translated_text'), with: expired_card.translated_text
          click_on t(:check_translation)

          expect(current_path).to eq random_cards_path
          expect(page).to have_text t(:translation_correct)
          expect(page).to_not have_text expired_card.original_text
        end
      end

      context 'incorrectly' do
        scenario 'and gets error message if translation is not provided' do
          login user
          visit random_cards_path
          fill_in t('helpers.labels.card.translated_text'), with: ''
          click_on t(:check_translation)

          expect(current_path).to eq card_check_path(expired_card)
          expect(page).to have_text t(:translation_cannot_be_blank)
          expect(page).to have_text expired_card.original_text
        end

        scenario 'and gets message with correct translation' do
          login user
          visit random_cards_path
          fill_in t('helpers.labels.card.translated_text'), with: 'Wrong translation'
          click_on t(:check_translation)

          expect(current_path).to eq random_cards_path
          expect(page).to have_text "#{t :translation_correct}: #{expired_card.translated_text}"
          expect(page).to have_text expired_card.original_text
        end
      end

      context 'typo' do
        scenario 'user makes a typo in translation' do
          login user
          visit random_cards_path
          fill_in t('helpers.labels.card.translated_text'), with: expired_card.translated_text + 's'
          click_on t(:check_translation)

          expect(current_path).to eq random_cards_path
          expect(page).to have_text t(:typo_happend)
        end
      end
    end
  end
end
