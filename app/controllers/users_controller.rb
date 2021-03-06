require 'rubygems'
require 'rbconfig'
require 'mechanize'
require 'open-uri'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :following, :followers, :notifications]
  before_action :set_stream, only: [:show]
  before_action :have_sidebar, except: [:new, :edit, :index]
  before_action :other_user, only: [:show]

  skip_before_action RubyCAS::Filter, only: [:index]
  skip_before_action :current_user, only: [:index, :new, :create]

  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: @users.where("first_name like ?", "%#{params[:q]}%") }
    end
  end

  def show
    @tweet = Tweet.new
    @id = params[:id]
    if @id.nil?
      @user = User.find(current_user.id)
    else
      @user = User.find(@id)
    end
  end

  # GET /users/new
  def new
    @user = User.new
    @net_id = session[:cas_user]
    @user.netid = @net_id
    @user.search_ldap(@net_id)
    @user.get_user if @user.first_name.nil?
    if !current_user(false)
      @user.default = true
    else
      @user.default = false
    end
  end

  # GET /users/1/edit
  def edit
    @id = params[:id]
    if @id.nil?
      @user = User.find(current_user.id)
    else
     
      @user = User.find(@id)
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.netid = session[:cas_user]
    if !current_user(false)
      @user.default = true
    else
      @user.default = false
    end
    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path(delete: false) }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        flash[:notice] = "User could not be saved"        
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    old_handle = @user.handle
    respond_to do |format|
      if @user.update(user_params)
        format.html { 
          if old_handle != @user.handle
            @user.replace_all_mentions_in_tweets(old_handle, @user.handle)
          end
          redirect_to root_path
        }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    if User.where(netid: session[:cas_user]).length == 1 || !@user.default
      @user.destroy
      @user.tweets.each do |tweet|
        tweet.destroy
      end
      respond_to do |format|
        format.html { 
          if session[:current_account] == @user.id || @user.default
            session[:current_account] = nil
            redirect_to log_out_path(delete: true)
          else
            redirect_to users_path
          end }
        format.json { head :no_content }
      end
    else
      redirect_to "http://www.youtube.com/watch?v=mJXYMDu6dpY"
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users
    # .paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers
    # .paginate(page: params[:page])
    render 'show_follow'
  end

  def favorites
    @title = "Favorites"
    @user = User.find(params[:id])
    @tweets = @user.favorites
    # .paginate(page: params[:page])
    render 'show_favorites'
  end
  

  def switch_user
    @user = User.find(params[:id])
    session[:current_account] = @user.id
    redirect_to users_path
  end

  def show_stuff
    @a = Mechanize.new
    @a.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    @page = @a.get 'https://students.yale.edu/facebook/PhotoPage?currentIndex=-1&numberToGet=-1'
  end

  def default
    @old_default = User.where(netid: session[:cas_user], default: true).first
    @old_default.default = false
    @old_default.save
    @new_default = User.find(params[:id])
    @new_default.default = true
    @new_default.save
    redirect_to users_path
  end

  def set_stream
    @total_stream = []

    @user.tweet_stream.each do |post|
      @total_stream << post
    end

    @user.retweet_stream.each do |post|
        @total_stream << post
    end
  end

  def notifications
    @tweet = Tweet.new()
    @mentions = []
    Tweet.all.each do |tweet|
      if !tweet.all_mentions_in_tweet.empty? && tweet.all_mentions_in_tweet.include?('@' + @user.handle)
        @mentions << tweet
      end 
    end

    @notifications = []
    Notification.all.each do |notification|
      if notification.user_id == @user.id
        @notifications << notification
      end
    end
    render 'show_notification'
  end

  def have_sidebar
   @have_sidebar = true
  end

  def other_user
   @other_user = true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if params[:id] == nil
        @user = current_user
      else
        @user = User.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :handle, :biography, 
        :current_location, :email, :college, :user_tokens, :image_url)
    end
end
