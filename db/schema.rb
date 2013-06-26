ActiveRecord::Schema.define(version: 20130625203224) do

  create_table "favorite_tweets", force: true do |t|
    t.integer  "tweet_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.boolean  "retweeted"
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
    t.string   "image_url"
    t.string   "college"
  end

end