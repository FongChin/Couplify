class RemoveImageAndAddImageUrl < ActiveRecord::Migration
  def change
    drop_attached_file :messages, :image
    
    add_column :messages, :image_url, :text
  end
end
