class AddRetweetedToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :retweeted, :boolean
  end
end
