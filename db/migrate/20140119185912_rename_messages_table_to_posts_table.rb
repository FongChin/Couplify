class RenameMessagesTableToPostsTable < ActiveRecord::Migration
  def change
    rename_table :messages, :posts
  end
end
