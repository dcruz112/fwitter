class ApplicationController < ActionController::Base
  before_action RubyCAS::Filter
  before_action :current_user
  helper_method :current_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def current_user(redirect=true)
  	@possible_user_list = User.where(netid: session[:cas_user])
    if !@possible_user_list.empty?
      @current_user = @possible_user_list.first
    elsif redirect
      redirect_to new_user_path and return
    else
      nil
    end
  end
end
