class Retweet < ActiveRecord::Base
	belongs_to :tweet
	belongs_to :user

	def time_since_retweet
		seconds = Time.now - self.updated_at
		if seconds < 15
			display = "Just Now"
		elsif seconds < 59.5    #less than 59.5 seconds
			display = seconds.round(0).to_s + "s"
		elsif seconds < (3600-30)    #less than 59.5 minutes
			display = (seconds/60).round(0).to_s + "m"
		elsif seconds < (86400-1800)     #less than 23.5 hours
			display = (seconds/3600).round(0).to_s + "h"
		elsif seconds < 86400*2    #less than 2 days
			display = "Yesterday"
		elsif seconds < 86400*7    #less than 1 week
			display = self.updated_at.strftime("%A")
		else                      #more than 1 week
			mon = self.updated_at.month
			day = self.updated_at.day.to_s	
			display = day + convert_month_number_to_month_name(mon).to_s
		end
		
		return display
	end


	def convert_month_number_to_month_name(mo)
		months = { 1 => " Jan", 2 => " Feb", 3 =>" Mar", 4 => " Apr", 5 => " May", 6 => " Jun", 7 => " Jul", 8=> " Aug", 9=> " Sep", 10 => " Oct", 11 => " Nov", 12 => " Dec" }
		return months[mo]
	end

	def self.from_users_followed_by(user)
		followed_user_ids = "SELECT followed_id FROM relationships
			WHERE follower_id = :user_id"
		where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
			followed_user_ids: followed_user_ids, user_id: user.id)
	end

	
end
