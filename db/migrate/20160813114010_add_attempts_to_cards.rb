class AddAttemptsToCards < ActiveRecord::Migration
  def change
    add_column :cards, :attempts, :integer, default: 0, null: false
  end
end
