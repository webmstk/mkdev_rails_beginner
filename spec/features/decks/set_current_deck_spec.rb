# require 'feature_helper'

# feature 'current deck' do
  # given!(:user) { create :user, password: 123, password_confirmation: 123 }
  # given!(:deck1) { create :deck, user: user, current: true }
  # given!(:deck2) { create :deck, user: user, current: false }

  # scenario 'user changes current deck', js: true do
    # login user
    # visit decks_path

    # choose("current_#{deck2.id}")
    # deck2.reload
    # expect(deck2.current).to eq true
  # end
# end
