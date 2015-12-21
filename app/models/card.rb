class Card < ActiveRecord::Base
  validates :original_text, :translated_text, :review_date, presence: true
  validate :text_and_translate_does_not_match

  before_validation :set_review_date

  scope :review, -> { where('review_date < ?', Time.now) }


  def text_and_translate_does_not_match
    if original_text.mb_chars.downcase == translated_text.mb_chars.downcase
      errors.add(:translated_text, I18n.t(:match, scope: [:activerecord,
                                                          :errors,
                                                          :models,
                                                          :card,
                                                          :attributes,
                                                          :translated_text])) # безобразие!
    end
  end

  def set_review_date
    self.review_date = 3.days.from_now
    self
  end


  def translation_correct?(translation)
    translated_text.casecmp(translation) == 0
  end
end
