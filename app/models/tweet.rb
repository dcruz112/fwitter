class Tweet < ActiveRecord::Base
	belongs_to :user
	has_many :favorite_tweets
	has_many :favorited_by, through: :favorite_tweets, source: :user
	has_many :retweets
	has_many :mentions


	def mentions
	  @tweet_words = self.content.split(' ')
	  @mentions = []
      @tweet_words.each do |word|
        if word[0] == '@' && !User.where(handle: word[1..-1]).empty?
          @mentions << word
        end
      end
      return @mentions
	end

	def self.from_users_followed_by(user)
		followed_user_ids = "SELECT followed_id FROM relationships
			WHERE follower_id = :user_id"
		where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
			followed_user_ids: followed_user_ids, user_id: user.id)
	end

end
