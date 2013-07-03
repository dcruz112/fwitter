# require 'net/ldap'
require 'mechanize'

class User < ActiveRecord::Base
	mount_uploader :image_url, ImageUrlUploader

	has_many :tweets
	has_many :retweets
	has_many :favorite_tweets
	has_many :favorites, through: :favorite_tweets, source: :tweet

	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower


	attr_reader :user_tokens

  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end

	NAME = KNOWN_AS = /^\s*Name:\s*$/i
	KNOWN_AS = /^\s*Known As:\s*$/i
	EMAIL = /^\s*Email Address:\s*$/i
	YEAR = /^\s*Class Year:\s*$/i
	SCHOOL = /^\s*Division:\s*$/i
	COLLEGE = /^\s*Residential College:\s*$/i
	LEAD_SPACE = /^\s+/
	TRAIL_SPACE = /\s+$/

	def make_cas_browser
	  browser = Mechanize.new
	  browser.get( 'https://secure.its.yale.edu/cas/login' )
	  form = browser.page.forms.first
	  form.username = ENV['netid']
	  form.password = ENV['password']
	  form.submit
	  browser
	end

	def get_user
	  browser = make_cas_browser
	  netid = self.netid

	  browser.get("http://directory.yale.edu/phonebook/index.htm?searchString=uid%3D#{netid}")

	  browser.page.search('tr').each do |tr|
	    field = tr.at('th').text
	    value = tr.at('td').text.sub(LEAD_SPACE, '').sub(TRAIL_SPACE, '')
	    case field
	    when KNOWN_AS
	      self.first_name = value
	    when NAME
	      name = value.split(' ')
	      self.first_name = name.first if self.first_name.nil?
	      self.last_name = name.last
	    when EMAIL
	  	  self.email = value
	    when COLLEGE
	      self.college = value.nil? ? "YC" : value
	    end
	  end
	end

	# def search_ldap(login)
	#     ldap = Net::LDAP.new(host: "directory.yale.edu", port: 389)
	#     filter = Net::LDAP::Filter.eq("uid", login)
	#     attrs = ["givenname", "sn", "eduPersonNickname", "telephoneNumber", "uid",
	#              "mail", "collegename", "curriculumshortname", "college", "class"]
	#     result = ldap.search(base: "ou=People,o=yale.edu", filter: filter, attributes: attrs)
	# 	if !result.empty?
	#     	@nickname = result[0][:eduPersonNickname]
	# 		if @nickname.empty?
	# 			self.first_name  = result[0][:givenname][0]
	# 		else
	# 		    self.first_name  = @nickname[0]
	# 		end
	# 		self.last_name   = result[0][:sn][0]
	# 		self.email   = result[0][:mail][0]
	# 		self.college = result[0][:college][0]
	# 	end
	# end

	validates :first_name, :handle, :email, presence: true
	validates :handle, uniqueness: { case_sensitive: false }
	validates :handle, allow_blank: true, format: { with: /\A[a-zA-Z0-9_]+\z/,
    message: "Only use letters, numbers, and '_'" }

	def handle_at
		"@" + handle
	end

	def full_name
		first_name + " " + last_name
	end

	def following?(some_user)
		self.relationships.find_by(followed_id: some_user.id)
	end

	def follow!(other_user)
		self.relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy
	end

	def tweet_stream
		Tweet.from_users_followed_by(self) 
	end

	def retweet_stream
		Retweet.from_users_followed_by(self)
	end

	def replacing_all_mentions_in_tweets_after_editing_handle(old_handle, new_handle)
		if old_handle != new_handle
	  	Tweet.all.each do |tweet|
	  		if ( tweet.content[("#{old_handle}" + " ")] != nil )  ||  ( tweet.content.ends_with?(old_handle) )
		  		segments_of_tweet = tweet.content.rpartition(old_handle)
		  		tweet.content = [segments_of_tweet[0], new_handle, segments_of_tweet[2]].join
		  		tweet.save
		   	end
		  end
		end
	end

end
