class CreateFavoriteTweets < ActiveRecord::Migration
  def change
    create_table :favorite_tweets do |t|
      t.integer :tweet_id
      t.integer :user_id

      t.timestamps
    end
  end
end
