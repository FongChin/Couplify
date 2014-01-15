class AddNameColsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fname, :string
    add_column :users, :lname, :string
    
    User.all.each do |user|
      user.fname = ""
      user.lname = ""
      user.save!
    end
    
    change_column :users, :fname, :string, :null => false
    change_column :users, :lname, :string, :null => false
  end
end
