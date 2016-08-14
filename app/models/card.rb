class Card < ActiveRecord::Base
  GUESS_ATTEMPTS = 2
  REVIEW_DELAY_DAYS = {
    1 => 0.5,
    2 => 3,
    3 => 7,
    4 => 14,
    5 => 30
  }

  mount_uploader :image, ImageUploader

  belongs_to :user
  belongs_to :deck

  validates :original_text, :translated_text, :review_date, :deck_id, presence: true
  validate :text_and_translate_does_not_match

  before_validation :set_review_date, unless: :review_date

  scope :review, -> { where('review_date < ?', Time.now) }


  def text_and_translate_does_not_match
    return if original_text.nil? || translated_text.nil?

    if original_text.mb_chars.downcase == translated_text.mb_chars.downcase
      errors.add(:translated_text, :match)
    end
  end

  def set_review_date
    self.review_date = Time.now
  end

  def delay_review_date
    key = REVIEW_DELAY_DAYS.has_key?(success) ? success : REVIEW_DELAY_DAYS.keys.last
    self.update! review_date: Time.now + REVIEW_DELAY_DAYS[key].days
  end

  def success_up
    self.update! success: success.next
  end

  def success_reset
    self.update! success: 0
  end

  def translated_correct
    success_up
    delay_review_date
  end

  def attempts_up
    self.update! attempts: attempts.next
  end

  def attempts_reset
    self.update! attempts: 0
  end

  def attempts_recalc
    if attempts < GUESS_ATTEMPTS
      attempts_up
    else
      attempts_reset
      success_reset
    end
  end

  def translation_correct? translation
    translated_text.casecmp(translation) == 0
  end

  def typo_in_translation? translation
    levenshtein = Levenshtein.distance(translated_text.mb_chars.downcase.to_s, translation.mb_chars.downcase.to_s)
    return nil if levenshtein.zero?
    levenshtein == 1
  end
end
