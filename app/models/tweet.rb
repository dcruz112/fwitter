class Tweet < ActiveRecord::Base
	belongs_to :user
	has_many :favorite_tweets
	has_many :favorited_by, through: :favorite_tweets, source: :user
	has_many :retweets
	has_many :mentions
  has_many :hashes

  attr_reader :current_hash



	def all_mentions_in_tweet
	  @tweet_words = self.content.split(' ')
	  @mentions = []
      @tweet_words.each do |word|
        if word[0] == '@' && !User.where(handle: word[1..-1]).empty?
          @mentions << word
        end
      end
      return @mentions
	end




	def all_hashes_in_tweet
	  @tweet_words = self.content.split(' ')
	  hashes = []
      @tweet_words.each do |word|
        if word[0] == '#'
          hashes << word
        end
      end
      return hashes
	end

	def is_hash_in_tweet(current_hash)
      
      self.all_hashes_in_tweet.each do |hash|
        puts hash
        puts "+++++++++++++++++++"
        puts current_hash
        puts "+++++++++++++++++++"
        if hash == current_hash
         puts hash
          return true
        end
      end

      return false
	
  end

end