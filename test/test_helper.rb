ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
#require 'ffaker'

class ActiveSupport::TestCase
 #ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  RubyCAS::Filter.fake('testnetid')

   def log_in_as(user)
     session[:user_id] = users(user).id
   end

   def log_out
     session.delete :user_id
   end
  
   def setup
     log_in_as :one if defined? session
   end
  

  # Add more helper methods to be used by all tests here...
end
