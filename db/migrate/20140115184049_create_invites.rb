class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :user_id, :null => false
      t.string :p_email, :null => false
      t.boolean :waiting, :null => false, :default => true
      t.boolean :accept_invitation, :null => false, :default => false

      t.timestamps
    end
    add_index :invites, [:user_id, :p_email], :unique => true
  end
end
