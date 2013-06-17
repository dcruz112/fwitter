class AddUserIdToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :user_id, :FixNum
  end
end
