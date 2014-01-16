class CreateCouples < ActiveRecord::Migration
  def change
    create_table :couples do |t|
      t.integer :u1_id, :null => false
      t.integer :u2_id, :null => false
      t.date :anniversary_date, :null => false, :default => Time.now.strftime("%Y-%m-%d")
      t.string :profile_name, :null => false

      t.timestamps
    end
    add_index :couples, :u1_id, :unique => true
    add_index :couples, :u2_id, :unique => true
    add_index :couples, :profile_name, :unique => true
  end
end
