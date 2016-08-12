require 'rails_helper'

RSpec.describe Deck, type: :model do
  it { should have_many :cards }
  it { should belong_to :user }
  it { should validate_presence_of :name }
  it { should validate_presence_of :user_id }

  describe '#set_current' do
    let(:user) { create :user }
    let(:deck) { create :deck, current: false, user: user }
    let!(:deck2) { create :deck, current: true, user: user }

    it 'sets current deck' do
      deck.set_current user
      expect(deck.current).to eq true
    end

    it 'only one deck is current at the moment' do
      deck.set_current user
      deck2.reload
      expect(deck2.current).to eq false
    end
  end
end
