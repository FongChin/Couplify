class AddIndexToInvites < ActiveRecord::Migration
  def change
    add_index :invites, :user_id, :unique => true
  end
end
