require 'net/ldap'
require 'mechanize'

class User < ActiveRecord::Base
	mount_uploader :image_url, ImageUrlUploader

	has_many :tweets
	# accepts_nested_attributes_for :tweets
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
	  form.password = ENV['netid_password']
	  form.submit
	  browser
	end

	def get_user
	  browser = make_cas_browser
	  netid = self.netid

	  browser.get("http://directory.yale.edu/phonebook/index.htm?searchString=uid%3D#{netid}")

	  fname = ""
	  browser.page.search('tr').each do |tr|
	    field = tr.at('th').text
	    value = tr.at('td').text.sub(LEAD_SPACE, '').sub(TRAIL_SPACE, '')
	    case field
	    when NAME
	      name = value.split(' ')
	      fname = name.first
	      self.last_name = name.last
	      self.first_name = fname 
	    when KNOWN_AS
	      self.first_name = value
	    when EMAIL
	  	  self.email = value
	    when COLLEGE
	      self.college = value
	    end
	    self.college ||= "YC"
	  end
	  self.get_bio(fname, self.last_name)
	end

	def get_bio(fname, lname)
	  browser = make_cas_browser
	  self.biography = "Hi!"
	  browser.get("https://students.yale.edu/facebook/ChangeCollege?newOrg=Yale%20College")
	  browser.get("https://students.yale.edu/facebook/Search?searchTerm=#{fname}%20#{lname}&searchResult=true")
	  page = browser.page.search("div.student_info")
	  if !page.empty?
	  	len = page.children.length
	    major = page.children[len - 3].text
	    dob = page.children.last.text.split(' ')
	    location = page.children[len - 5].text
	  	if major == "Undeclared"
	  		self.biography += " I'm in #{page.first.children.text} and am still trying to figure out my major."
	  	else
	  		self.biography += " I'm a #{major} major in #{page.first.children.text}."
	  	end
	  	self.biography += " My birthday is #{month_abbr_converter(dob.first)} #{dob.last.to_i.ordinalize}."
	  	self.current_location = "#{location}"
	  end
	end
	

	def month_abbr_converter(month)
		months = { "Jan" => "January", "Feb" => "February", "Mar" => "March", 
			"Apr" => "April", "May" => "May", "Jun" => "June", "Jul" => "July",
			"Aug" => "August", "Sep" => "September", "Oct" => "October", 
			"Nov" => "November", "Dec" => "Decemeber"}
		return months[month]
	end

	def search_ldap(login)
	    ldap = Net::LDAP.new(host: "directory.yale.edu", port: 389)
	    filter = Net::LDAP::Filter.eq("uid", login)
	    attrs = ["givenname", "sn", "eduPersonNickname", "telephoneNumber", "uid",
	             "mail", "collegename", "curriculumshortname", "college", "class"]
	    result = ldap.search(base: "ou=People,o=yale.edu", filter: filter, attributes: attrs)
		if !result.empty?
			fname  = result[0][:givenname][0]
			self.first_name = fname
			self.last_name   = result[0][:sn][0]
	    	@nickname = result[0][:eduPersonNickname]
			if !@nickname.empty?
			    self.first_name  = @nickname[0]
			end
			self.email   = result[0][:mail][0]
			self.college = result[0][:college][0]
			self.get_bio(fname, self.last_name)
		end
	end

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

	def mention_count(number)
		all_instances_of_mentions = []
		h = Hash.new(0)	
		Tweet.all.each do |tweet|
			all_instances_of_mentions << tweet.all_mentions_in_tweet
		end
		all_instances_of_mentions.flatten.each {|v| h[v] +=1}
		s = Hash[h.sort_by{|k, v| v}.reverse].keys[0..(number-1)]
		s = s[0..(number-1)] if s.length > number
		return s
	end

	def hash_count(number)
		all_instances_of_hashes = []
		h = Hash.new(0)	
		Tweet.all.each do |tweet|
			if ((Time.now - tweet.created_at) < 86400 ) 
				all_instances_of_hashes << tweet.all_hashes_in_tweet
			end
		end
		all_instances_of_hashes.flatten.each {|v| h[v] +=1}
		s = Hash[h.sort_by{|k, v| v}.reverse].keys
		s = s[0..(number-1)] if s.length > number
		return s
	end
end
