class Retweet < ActiveRecord::Base
	belongs_to :tweet
	belongs_to :user

	def self.from_users_followed_by(user)
		followed_user_ids = "SELECT followed_id FROM relationships
			WHERE follower_id = :user_id"
		where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
			followed_user_ids: followed_user_ids, user_id: user.id)
	end
end
