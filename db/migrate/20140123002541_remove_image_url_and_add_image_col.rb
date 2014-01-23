class RemoveImageUrlAndAddImageCol < ActiveRecord::Migration
  def change
    remove_column :posts, :image_url
    change_table :posts do |t|
      t.attachment :image
    end
  end
end
