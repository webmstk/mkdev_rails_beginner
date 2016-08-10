class Deck < ActiveRecord::Base
  has_many :cards

  validates :name, presence: true

  scope :ordered, -> { order [name: :desc] }

  def set_current
    Deck.update_all current: false
    update_attribute :current, true
  end
end
