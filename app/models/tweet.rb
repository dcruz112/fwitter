class Tweet < ActiveRecord::Base
	belongs_to :user
	has_many :favorite_tweets
	has_many :favorited_by, through: :favorite_tweets, source: :user
	has_many :retweets



	def time_since_tweet
		seconds = Time.now - self.updated_at
		if seconds < 15
			display = "Just Now"
		elsif seconds < 60    #less than 1 minute
			display = seconds.round(0).to_s + "s"
		elsif seconds < 3600    #less than 1 hour
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

end
