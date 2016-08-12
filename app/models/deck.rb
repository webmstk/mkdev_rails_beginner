class Deck < ActiveRecord::Base
  has_many :cards
  belongs_to :user

  validates :name, :user_id, presence: true

  scope :ordered, -> { order [name: :desc] }

  def set_current user
    user.decks.update_all current: false
    update_attribute :current, true
  end
end
