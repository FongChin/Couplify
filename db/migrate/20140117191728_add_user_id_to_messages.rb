class AddUserIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :user_id, :integer, :null => false
  end
end
