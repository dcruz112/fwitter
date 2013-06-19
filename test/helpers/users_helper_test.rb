require 'test_helper'

class UsersHelperTest < ActionView::TestCase


	test "user attributes must not be empty" do
		user = User.new
		assert user.invalid?
		assert user.errors[:first_name].any?
		assert user.errors[:last_name].any?
	    #assert user.errors[:netid].any?
		assert user.errors[:handle].any?
	end





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


	test "user is not valid without a unique handle - i18n" do
		user = User.new(handle: users(:three).handle, 
								first_name: "yyy", 
								last_name: "zzz", 
								biography: "new to this",
								current_location: "newhaven",
								netid:"abc123")
		assert user.invalid?
		assert_equal ["has already been taken"], user.errors[:handle]
		#assert_equal [I18n.translate('errors.messages.taken')], user.errors[:handle]
	end




end
