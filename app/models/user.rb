require 'net/ldap'

class User < ActiveRecord::Base
	has_many :tweets
	has_many :favorite_tweets
	has_many :favorites, through: :favorite_tweets, source: :tweet
	
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

	def search_ldap(login)
	    ldap = Net::LDAP.new(host: "directory.yale.edu", port: 389)
	    filter = Net::LDAP::Filter.eq("uid", login)
	    attrs = ["givenname", "sn", "eduPersonNickname", "telephoneNumber", "uid",
	             "mail", "collegename", "curriculumshortname", "college", "class"]
	    result = ldap.search(base: "ou=People,o=yale.edu", filter: filter, attributes: attrs)
		if !result.empty?
	    	@nickname = result[0][:eduPersonNickname]
			if @nickname.empty?
				self.first_name  = result[0][:givenname][0]
			else
			    self.first_name  = @nickname[0]
			end
			self.last_name   = result[0][:sn][0]
			self.email   = result[0][:mail][0]
			self.college = result[0][:college][0]
		end
	end

	validates :first_name, :last_name, :handle, :email, presence: true
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
		Relationship.find_by(followed_id: some_user.id)
	end

	def follow!(other_user)
		self.relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy
	end

	def stream
		Tweet.from_users_followed_by(self)
	end
end
