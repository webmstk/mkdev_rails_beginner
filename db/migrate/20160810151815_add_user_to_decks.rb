class AddUserToDecks < ActiveRecord::Migration
  def change
    add_reference :decks, :user, index: true, foreign_key: true
  end
end
