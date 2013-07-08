class Retweet < ActiveRecord::Base
	belongs_to :tweet
	belongs_to :user

	# self.per_page = 10

	def all_mentions_in_tweet
	  @retweet_words = self.content.split(' ')
	  mentions = []
	  @retweet_words.each do |word|
	    if word[0] == '@' && !User.where(handle: word[1..-1]).empty?
	      mentions << word
	    end
      end
	  return mentions
	end


	def is_hash_in_tweet(current_hash)
	  self.all_hashes_in_tweet.each do |hash|
	    return true   if hash == current_hash
	  end
	  return false
	end

  def all_hashes_in_tweet
    @retweet_words = self.content.split(' ')
    hashes = []
    @retweet_words.each do |word|
      hashes << word    if word[0] == '#'
    end
    return hashes
  end

	def self.from_users_followed_by(user)

		followed_user_ids = "SELECT followed_id FROM relationships
			WHERE follower_id = :user_id"
		where("user_id IN (#{followed_user_ids}) OR poster_id = :user_id", 
			followed_user_ids: followed_user_ids, user_id: user.id)
	end
end
