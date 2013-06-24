require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test that destroying a user also destroys user's relationships
  # and same goes for destroying tweets
  # test that object responds to relationships and followed users
  # responds to following? and follow!

  # create a sample user, have them follow a different user, test that
  # they are following that user, and that its followed users include
  # that user

  # once a user is unfollowed, make sure you aren't following them
  # and that followed_users no longer icnludes them

  # you have to test for reverse relationships in the same way as relationships,
  # ensuring you respond to followers as well
  # do the other user's followers include you once you follow them?
end
