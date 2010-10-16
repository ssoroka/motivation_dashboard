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

ActiveRecord::Schema.define(:version => 20101016031611) do

  create_table "dashboards", :force => true do |t|
    t.string   "name",       :default => "Motivation Dashboard"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dashboards", ["user_id"], :name => "index_dashboards_on_user_id"

  create_table "data_sets", :force => true do |t|
    t.text     "config"
    t.text     "data"
    t.integer  "data_source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "data_sets", ["data_source_id"], :name => "index_data_sets_on_data_source_id"

  create_table "data_sources", :force => true do |t|
    t.text     "config"
    t.string   "api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "data_sources", ["api_key"], :name => "index_data_sources_on_api_key"

  create_table "users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widgets", :force => true do |t|
    t.integer  "dashboard_id"
    t.integer  "position"
    t.integer  "widget_size",    :default => 1
    t.integer  "data_set_id"
    t.integer  "widget_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "widgets", ["dashboard_id"], :name => "index_widgets_on_dashboard_id"
  add_index "widgets", ["data_set_id"], :name => "index_widgets_on_data_set_id"

end
