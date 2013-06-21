require 'net/ldap'

class User < ActiveRecord::Base
	has_many :tweets

	def search_ldap(login)
	    ldap = Net::LDAP.new(:host => "directory.yale.edu", :port => 389)
	    filter = Net::LDAP::Filter.eq("uid", login)
	    attrs = ["givenname", "sn", "eduPersonNickname", "telephoneNumber", "uid",
	             "mail", "collegename", "curriculumshortname", "college", "class"]
	    result = ldap.search(:base => "ou=People,o=yale.edu", :filter => filter, :attributes => attrs)
		if !result.empty?
	    	@nickname = result[0][:eduPersonNickname]
			if @nickname.empty?
				self.first_name  = result[0][:givenname][0]
			else
			    self.first_name  = @nickname[0]
			end
			self.last_name   = result[0][:sn][0]
			self.email   = result[0][:mail][0]
		end
	end

	validates :first_name, :last_name, :handle, :email, presence: true
	validates :handle, uniqueness: { case_sensitive: false }
	#validates :netid, uniqueness: true
	validates :handle, allow_blank: true, format: { with: /\A[a-zA-Z0-9_]+\z/,
    message: "Only use letters, numbers, and '_'" }

	def handle_at
		"@" + handle
	end

	def full_name
		first_name + " " + last_name
	end
end
