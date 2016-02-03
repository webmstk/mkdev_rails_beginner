class SorceryCore < ActiveRecord::Migration
  def change
    remove_column :users, :password
    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string
    change_column_null :users, :email, false

    add_index :users, :email, unique: true
  end
end