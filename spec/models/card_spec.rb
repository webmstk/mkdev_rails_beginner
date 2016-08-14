require 'rails_helper'

RSpec.describe Card, type: :model do
  let(:date) { Time.now }
  let(:card) { create :card, review_date: date }

  it { should belong_to :user }
  it { should belong_to :deck }
  it { should validate_presence_of :deck_id }
  # it { should validate_presence_of :user_id }

  describe '.create' do
    it 'sets review_date to today if nil' do
      allow(Time).to receive(:now).and_return(date)
      card.save
      expect(card.review_date).to eq date
    end
  end

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
    Card::REVIEW_DELAY_DAYS.each do |success, delay|
      it "success #{success} delays to #{delay} days" do
        card.update review_date: date, success: success
        allow(Time).to receive(:now).and_return(date)
        card.delay_review_date
        expect(card.review_date).to eq date + delay.days
      end
    end

    it "success #{Card::REVIEW_DELAY_DAYS.keys.last + 1} delays to #{Card::REVIEW_DELAY_DAYS.values.last} days" do
      card.update review_date: date, success: Card::REVIEW_DELAY_DAYS.keys.last + 1
      allow(Time).to receive(:now).and_return(date)
      card.delay_review_date
      expect(card.review_date).to eq date + Card::REVIEW_DELAY_DAYS.values.last.days
    end
  end


  describe '#success_up' do
    it 'increments success by 1' do
      expect { card.success_up }.to change(card, :success).by 1
    end
  end

  
  describe '#success_reset' do
    before { card.update_column :success, 2 }

    it 'set success to zero' do
      card.success_reset
      expect(card.success).to eq 0
    end
  end


  describe '#translated_correct' do
    it 'invokes #success_up' do
      expect(card).to receive(:success_up)
      card.translated_correct
    end

    it 'invokes #delay_review_date' do
      expect(card).to receive(:delay_review_date)
      card.translated_correct
    end
  end


  describe '#attempts_up' do
    it 'increments attempts by 1' do
      expect { card.attempts_up }.to change(card, :attempts).by 1
    end
  end

  
  describe '#attempts_reset' do
    before { card.update_column :attempts, 2 }

    it 'set attempts to zero' do
      card.attempts_reset
      expect(card.attempts).to eq 0
    end
  end


  describe '#attempts_recalc' do
    context "attempts less than #{Card::GUESS_ATTEMPTS}" do
      before { card.update attempts: 0 }

      it 'invokes #attempts_up' do
        expect(card).to receive(:attempts_up)
        card.attempts_recalc
      end
    end

    context "attempts over or equal #{Card::GUESS_ATTEMPTS}" do
      before { card.update attempts: Card::GUESS_ATTEMPTS }

      it 'invokes #attempts_reset' do
        expect(card).to receive(:attempts_reset)
        card.attempts_recalc
      end

      it 'invokes #success_reset' do
        expect(card).to receive(:success_reset)
        card.attempts_recalc
      end
    end
  end


  describe '#text_and_translate_does_not_match' do
    let(:card) { build :card, original_text: 'привет', translated_text: 'ПриВет' }

    it 'sets an error if translated_text is equal to original_text' do
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
