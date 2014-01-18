class CreateEmailErrorsTable < ActiveRecord::Migration
  def change
    create_table :email_errors do |t|
      t.text :error_msg
      t.text :params
      
      t.timestamps
    end
  end
end