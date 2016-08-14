class AddSuccessToCards < ActiveRecord::Migration
  def change
    add_column :cards, :success, :integer, default: 0, null: false
  end
end
