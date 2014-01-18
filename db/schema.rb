# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140118001925) do

  create_table "couples", :force => true do |t|
    t.integer  "u1_id",                                      :null => false
    t.integer  "u2_id",                                      :null => false
    t.date     "anniversary_date", :default => '2014-01-15', :null => false
    t.string   "profile_name",                               :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "couples", ["profile_name"], :name => "index_couples_on_profile_name", :unique => true
  add_index "couples", ["u1_id"], :name => "index_couples_on_u1_id", :unique => true
  add_index "couples", ["u2_id"], :name => "index_couples_on_u2_id", :unique => true

  create_table "invites", :force => true do |t|
    t.integer  "user_id",                              :null => false
    t.string   "p_email",                              :null => false
    t.boolean  "waiting",           :default => true,  :null => false
    t.boolean  "accept_invitation", :default => false, :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.text     "message"
  end

  add_index "invites", ["user_id", "p_email"], :name => "index_invites_on_user_id_and_p_email", :unique => true
  add_index "invites", ["user_id"], :name => "index_invites_on_user_id", :unique => true

  create_table "messages", :force => true do |t|
    t.integer  "couple_id",                  :null => false
    t.text     "body",       :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "user_id",                    :null => false
    t.text     "image_url"
  end

  add_index "messages", ["couple_id"], :name => "index_messages_on_couple_id"

  create_table "users", :force => true do |t|
    t.string   "email",                      :default => "", :null => false
    t.string   "encrypted_password",         :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "first_name",                                 :null => false
    t.string   "last_name",                                  :null => false
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
