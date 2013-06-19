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
		end
	end

	def full_name
		first_name + " " + last_name
	end
end
