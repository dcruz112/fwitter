class Tweet < ActiveRecord::Base
	belongs_to :user


	def time_since_tweet
		seconds = Time.now - self.updated_at
		

		if seconds < 60
			type = "s"
			display = seconds
		elsif seconds < 3600
			type = "m"
			display = (seconds/60).round(0)
		elsif seconds < 86400
			type = "h"
			display = (seconds/3600).round(0)
		elsif seconds >= 86400
			mon = self.updated_at.month
			day = self.updated_at.day
			
				if mon == 1 
					m = " Jan"
				elsif mon == 2 
					m = " Feb"
				elsif mon == 3 
					m= " Mar"
				elsif mon == '4' 
					m= " Apr"
				elsif mon == '5' 
					m= " May"
				elsif mon == 6 
					m= " Jun"
				elsif mon == '7' 
					m= " Jul"
				elsif mon == '8' 
					m= " Aug"
				elsif mon == 9 
					m= " Sep"
				elsif mon == 10 
					m= " Oct"
				elsif mon == 11 
					m= " Nov"
				elsif mon == 12 
					m= " Dec"
				end


			type = m
			#type = mon.convert_month_number_to_month_name
			display = day
		end
		val = display.to_s + type.to_s
		return val
	end


	# def convert_month_number_to_month_name
	
	# 	if self == 1 
	# 		m = "Jan"
	# 	elsif self == 2 
	# 		m= "Feb"
	# 	elsif self == 3 
	# 		m= "Mar"
	# 	elsif self == '4' 
	# 		m= "Apr"
	# 	elsif self == '5' 
	# 		m= "May"
	# 	elsif self == 6 
	# 		m= "Jun"
	# 	elsif self == '7' 
	# 		m= "Jul"
	# 	elsif self == '8' 
	# 		m= "Aug"
	# 	elsif self == 9 
	# 		m= "Sep"
	# 	elsif self == 10 
	# 		m= "Oct"
	# 	elsif self == 11 
	# 		m= "Nov"
	# 	elsif self == 12 
	# 		m= "Dec"
	# 	end

	# 	return m.to_s

	# end




end
