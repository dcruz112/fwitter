require 'test_helper'

class UsersHelperTest < ActionView::TestCase








	def new_user(input)
		User.new(first_name: "Lebron",
		last_name: "James",
		biography: "I play for the Miami Heat",
		current_location: "South Beach",
		netid: "lbj1",
		handle: input)
	end

	test "twitter_handle_valid?" do
		ok = %w{ 060600606__06 james_6_king 06kingjames kingjames06 }
		bad = %w{ @kingjames james@king.com jamesisthef&*^ingbest thekingjames.06 }

		ok.each do |name|
			assert new_user(name).valid?, "#{name} shouldn't be invalid"
		end
		
		bad.each do |name|
			assert new_user(name).invalid?, "#{name} shouldn't be valid"
		end
	end




end
