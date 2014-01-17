class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :couple_id, :null => false
      t.text :body, :null => false, :default => ""
      t.attachment :image

      t.timestamps
    end
    add_index :messages, :couple_id
  end
end
