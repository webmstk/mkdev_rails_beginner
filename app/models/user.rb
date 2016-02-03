class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :cards
  has_many :authentications, dependent: :destroy

  accepts_nested_attributes_for :authentications

  validates :email, :password, :password_confirmation, presence: true
  validates :email, uniqueness: true
  validates :password, confirmation: true
  validates :old_password, presence: true, on: :update


  def new_user?
    new_record?
  end
  # validates :old_password, presence: true, on: :update#, unless: Proc.new { |u|
  #   p 'oooooooo'
  #   u.reload
  #   p u
  #   p self.old_password
  #   # self.old_password == ''
  #   p self.valid_password?('')
  #   u.crypted_password.nil?
  # }
  # validate :check_old_password, on: :update
  attr_accessor :old_password

  def check_old_password
    # p 'aaaaaaaa'
    # p self.crypted_password
    # p self.old_password
    # return if self.old_password == ''
    p self
    errors.add(:old_password, I18n.t('activerecord.errors.models.user.attributes.old_password.match')) unless valid_password?(old_password)
  end

  # def self.authorize_by_provider(provider)
  #   user = login_from(provider)
  #   return user if user
  #
  #   begin
  #     user = create_from(provider)
  #   rescue
  #     user = User.where(email: @user_hash[:user_info]['email']).first
  #     user.create_authentication(provider, @user_hash[:uid]) if user
  #   end
  #
  #   if user
  #     reset_session
  #     auto_login(user)
  #   end
  #
  #   user
  # end

  def create_authentication(provider, uid)
    authentications.create(provider: provider, uid: uid)
  end
end
