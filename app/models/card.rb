class Card < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  belongs_to :user
  belongs_to :deck

  validates :original_text, :translated_text, :review_date, :deck_id, presence: true
  validate :text_and_translate_does_not_match

  before_validation :set_review_date, if: 'review_date.nil?'

  scope :review, -> { where('review_date < ?', Time.now) }


  def text_and_translate_does_not_match
    return if original_text.nil? || translated_text.nil?

    if original_text.mb_chars.downcase == translated_text.mb_chars.downcase
      errors.add(:translated_text, :match)
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
