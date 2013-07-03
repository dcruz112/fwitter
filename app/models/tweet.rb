class Tweet < ActiveRecord::Base
	belongs_to :user
	belongs_to :conversation
	has_many :favorite_tweets
	has_many :favorited_by, through: :favorite_tweets, source: :user
	has_many :retweets
	has_many :mentions
    has_many :hashes
    #has_many :replies

	attr_reader :current_hash

	# self.per_page = 10

	def all_mentions_in_tweet
	  @tweet_words = self.content.split(' ')
	  mentions = []
    @tweet_words.each do |word|
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
	  @tweet_words = self.content.split(' ')
	  hashes = []
    @tweet_words.each do |word|
      hashes << word    if word[0] == '#'
    end
    return hashes
	end

	def self.from_users_followed_by(user)
	  followed_user_ids = "SELECT followed_id FROM relationships
		WHERE follower_id = :user_id"
	  where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
	    followed_user_ids: followed_user_ids, user_id: user.id)
	end

	def replies
	  Tweet.where("reply_id = ?", id)
		# @tweet = Tweet.find(1)
		# reply_ids = "SELECT tweets WHERE reply_id = :tweet_id"
		# where(tweet_id: @tweet.id)
	end

	# def conversation(tweet)
	# 	conversation_tweet_ids = "SELECT tweet_id FROM replies
	# 		WHERE reply_id = :tweet_id"
	# 	where("tweet_id IN (#{reply_ids}) OR tweet_id = :tweet_id", 
	# 		reply_ids: reply_ids, tweet_id: tweet.id)
	# end
end