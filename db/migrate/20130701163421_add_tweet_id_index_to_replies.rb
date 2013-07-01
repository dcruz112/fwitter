class AddTweetIdIndexToReplies < ActiveRecord::Migration
  def change
  	add_index "replies", ["tweet_id"], name: "index_replies_on_tweet_id"
  end
end
