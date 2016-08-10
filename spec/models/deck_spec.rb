require 'rails_helper'

RSpec.describe Deck, type: :model do
  it { should have_many :cards }
  it { should validate_presence_of :name }

  describe '#set_current' do
    let(:deck) { create :deck, current: false }
    let!(:deck2) { create :deck, current: true }

    it 'sets current deck' do
      deck.set_current
      expect(deck.current).to eq true
    end

    it 'only one deck is current at the moment' do
      deck.set_current
      deck2.reload
      expect(deck2.current).to eq false
    end
  end
end
