class SessionsController < ApplicationController


  def log_in
  	current_user
	redirect_to current_user
  end

  def log_out
  	@current_user = nil
  	session[:cas_user] = nil
    RubyCAS::Filter.logout(self, root_path)
  end
end
