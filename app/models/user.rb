class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  attr_accessor :old_password

  has_many :cards
  has_many :decks
  has_many :authentications, dependent: :destroy

  accepts_nested_attributes_for :authentications

  validates :email, :locale, presence: true
  validates :email, uniqueness: { case_sensitive: false },
                    format: { with: /.+@.+\..+/,
                              message: I18n.t('activerecord.errors.models.user.attributes.email.format') }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validate :check_old_password, on: :update, if: -> { new_record? || changes[:crypted_password] }

  scope :with_pending_cards, -> { User.joins(:cards).merge(Card.review) }

  def check_old_password
    persisted_user = User.find id
    
    unless persisted_user.crypted_password.nil?
      if old_password.nil?
        errors.add(:old_password, I18n.t('activerecord.errors.models.user.attributes.old_password.blank'))
      elsif !persisted_user.valid_password?(old_password)
        errors.add(:old_password, I18n.t('activerecord.errors.models.user.attributes.old_password.match'))
      end
    end
  end

  def self.notify_pending_cards
    User.with_pending_cards.each do |user|
      NotificationMailer.pending_cards(user).deliver_later
    end
  end
end
