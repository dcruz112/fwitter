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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130624142016) do

    create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"


  create_table "retweets", force: true do |t|
    t.text     "content"
    t.string   "user_id"
    t.string   "poster_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tweet_id"
  end

  add_index "retweets", ["tweet_id"], name: "index_retweets_on_tweet_id"

  create_table "tweets", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "is_retweet"
    t.string   "poster_id"
  end

  add_index "tweets", ["user_id"], name: "index_tweets_on_user_id"

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "netid"
    t.string   "handle"
    t.text     "biography"
    t.string   "current_location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.boolean  "default"
  end

end
