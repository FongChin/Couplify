class AddMessageColumnToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :message, :text
  end
end
