class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]

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
    #current_user was already defined somewhere, while finding by :user_id
    # might not work for some reason. You were working from the wrong demo blog

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to root_path}
        format.json { render action: 'show', status: :created, location: @tweet }
      else
        format.html { render action: 'new' }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
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
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url }
      format.json { head :no_content }
    end
  end


  def retweet

    @old_tweet = Tweet.find(params[:id])

    @retweet = Tweet.new(content: ("RT: "+ @old_tweet.content), user_id: @old_tweet.user_id, is_retweet: true, poster_id: current_user.id)
    @retweet.save
    redirect_to tweets_path


    #@retweet.content = "RT: " + @retweet.content.to_s  + "\nRetweeted by: " + @current_user.full_name
  
  # @tweet = self
  #   @tweet.content = 'RT' + tweet.content.to_s
  # @tweet.updated_at = Time.now
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:content, :user_id, :is_retweet, :poster_id)
    end
end
