require 'rails_helper'

RSpec.describe Card, type: :model do
  it { should belong_to :user }
  it { should validate_presence_of :user_id }

  describe '#translation_correct?' do
    let(:card) { build :card, translated_text: 'hello' }

    it 'returns true if translation is correct' do
      expect(card.translation_correct?('HeLLo')).to eq true
    end

    it 'returns false if translation is incorrect' do
      expect(card.translation_correct?('wrong')).to eq false
    end
  end


  describe '#set_review_date' do
    let(:date) { Time.now }
    let!(:card) { build :card, review_date: date }

    it 'changes review_date to 3 days since now' do
      expect(Time).to receive(:now).and_return(date)
      expect(card.set_review_date.review_date).to eq (date + 3.days)
    end

    it 'returns self object' do
      expect(card.set_review_date).to eq card
    end
  end


  describe '#text_and_translate_does_not_match' do
    let(:card) { build :card, original_text: 'привет', translated_text: 'ПриВет' }

    it 'sets an error if translated_text equal to original_text' do
      card.text_and_translate_does_not_match
      expect(card.errors.messages[:translated_text]).to include 'Перевод не может совпадать с оригинальным текстом'
    end

    it 'does not set an error if translated_text differs from original_text' do
      card.translated_text = 'hello'
      card.text_and_translate_does_not_match

      expect(card.errors.messages[:translated_text]).to eq nil
    end
  end

end