class AddTweetIdToRetweet < ActiveRecord::Migration
  def change
    add_reference :retweets, :tweet, index: true
  end
end
