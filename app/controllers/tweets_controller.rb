class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy, :favorite]

  skip_before_action RubyCAS::Filter, only: [:index]
  skip_before_action :current_user, only: [:index]

  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = Tweet.all
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
    @tweet.poster_id = current_user.id
  end

  # GET /tweets/1/edit
  def edit 
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.poster_id = current_user.id
    @tweet.user = current_user
    @tweet.is_retweet = false

    # if @tweet.is_reply
    #   Tweet.find(@tweet.reply_id).replies << @tweet
    # end

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to root_path}
        format.json { render action: 'show', status: :created, location: @tweet }
      else
        @stream_items = []
        format.html { render action: 'new' }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end

    # if @tweet.is_reply
    #   Conversation.create(@tweet_id)

    #   Notification.new(user_id: Tweet.find(reply_id).user_id, img_url: User.find(Tweet.find(reply_id).user_id).img_url, content: @tweet.content, message: "#{User.find(@tweet.user_id).full_name} retweeted your tweet!"
    # end

  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    death = []
    death << Retweet.where(tweet_id: @tweet.id)
    death.flatten!
    death.each do |die|
      die.destroy
    end

    @tweet.destroy

    respond_to do |format|
      format.html { redirect_to tweets_url }
      format.json { head :no_content }
    end
  end

  def favorite
    type = params[:type]
    if type == "favorite"
      current_user.favorites << @tweet

      redirect_to :back, notice: 'Tweet favorited.'

      Notification.create(user_id: @tweet.user_id, image_url: current_user.image_url, message: "#{current_user.full_name} favorited your tweet!")

    elsif type == "unfavorite"
      current_user.favorites.delete(@tweet)
      redirect_to :back
    else
      redirect_to :back, notice: 'Something went wrong.'
    end
  end

  def hashes
    @current_hash = params[:hash_word]
    @hashes = [] 
    Tweet.all.each do |tweet|
      if tweet.is_hash_in_tweet(@current_hash)
        @hashes << tweet
      end 
    end
    render 'show_hashes'
  end


  private
  def set_tweet
    @tweet = Tweet.find(params[:id])    
  end

  def tweet_params
    params.require(:tweet).permit(:content, :user_id, :is_retweet, :poster_id, :is_reply, :reply_id)
  end

end
