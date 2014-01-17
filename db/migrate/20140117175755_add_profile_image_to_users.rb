class AddProfileImageToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.attachment :profile_image
    end
  end
  
  def down
    drop_attached_file :users, :profile_image
  end
end
